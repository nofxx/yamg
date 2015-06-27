module YAMG
  #
  # SPLASH
  #
  #
  class Splash
    attr_accessor :src, :bg, :image

    def initialize(args = {})
      @src = args['path']
      @bg = args['background']
    end

    #
    # Center image
    #
    def splash_center(size)
      icon_size = size.max / 4
      image.resize icon_size if image.dimensions.max >= icon_size
      image.background bg if bg
      image.combine_options do |o|
        o.gravity 'center'
        o.extent size.join('x') # "WxH"
      end
    end

    #
    # Composite 9 gravity
    #
    def splash_composite(base, icons)
      max = base.dimensions.min / 9
      icons.reduce(base) do |img, over|
        oimg = MiniMagick::Image.open(File.join(src, over))
        oimg.resize(max) if oimg.dimensions.max >= max
        img.composite(oimg) do |o|
          o.compose 'Over'
          o.gravity File.basename(over, '.*')
          o.geometry '+40%+40%'
        end
      end
    end

    def splash_work(screens, out)
      icons = YAMG.load_images(src)
      center = icons.find { |i| i =~ /center/ }
      icons.delete(center)
      @image = MiniMagick::Image.open(File.join(src, center))

      puts Rainbow("Starting splashes | #{icons.size}").blue
      screens.each do |file, size|
        to = File.join(out, file)
        image = splash_center(size)
        YAMG.write_out(splash_composite(image, icons), to)
      end
    end
  end
end
