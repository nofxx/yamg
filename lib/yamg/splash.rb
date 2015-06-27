module YAMG
  #
  # SPLASH
  #
  #
  class Splash
    attr_accessor :src, :bg, :size, :icons, :img

    def initialize(src, size, background)
      @src = src
      @size = size
      @bg = background
      @icons = YAMG.load_images(src)
   end

    #
    # Center image
    #
    def splash_center(center)
      icon_size = size.max / 4
      img.resize icon_size if img.dimensions.max >= icon_size
      img.background bg if bg
      img.combine_options do |o|
        o.gravity 'center'
        o.extent size.join('x') # "WxH"
      end
    end

    def compose(other, name)
      img.composite(other) do |o|
        o.compose 'Over'
        o.gravity File.basename(name, '.*')
        o.geometry '+40%+40%'
      end
    end

    #
    # Composite 9 gravity
    #
    def splash_composite(base)
      max = base.dimensions.min / 9
      icons.reduce(base) do |img, over|
        other = MiniMagick::Image.open(File.join(src, over))
        other.resize(max) if other.dimensions.max >= max
        compose(other, over)
      end
      base
    end

    def image
      center = icons.find { |i| i =~ /center/ }
      icons.delete(center)
      self.img = MiniMagick::Image.open(File.join(src, center))

      splash_composite(splash_center(center))
    end
  end
end
