module YAMG
  #
  # SPLASH
  #
  #
  class Splash
    attr_accessor :src, :bg, :size, :assets, :img

    def initialize(src, size, background)
      @src = src
      @size = size
      @bg = background
      @assets = YAMG.load_images(src)
      %w(bg background wallpaper).each do |i|
        @wallpaper = assets.delete("#{i}.png")
      end
      if center = assets.delete('center.png')
        @center =  File.join(src, center)
      end
      @center ||= File.join(File.dirname(__FILE__), 'assets', 'dot.png')
      YAMG.puts_and_exit("No sources in '#{src}'") if assets.empty?
      @img = MiniMagick::Image.open(@center)
   end

    #
    # Center image
    #
    def splash_start
      icon_size = size.max  / 9
      img.resize icon_size if img.dimensions.max >= icon_size
      img.combine_options do |o|
        o.gravity 'center'
        o.background bg if bg
        o.extent size.join('x') # "WxH"
      end

    end

    def compose(other, name)
      img.composite(other) do |o|
        o.gravity File.basename(name, '.*')
        o.compose 'Over'
        padding = name =~ /east|west/ ? '+40%' : '+0%'
        padding += name =~ /north|south/ ? '+40%' : '+0%'
        o.geometry padding
      end
    end

    #
    # Composite 9 gravity
    #
    def splash_composite
      max = size.min / 9
      assets.each do |over|
        other = MiniMagick::Image.open(File.join(src, over))
        other.resize(max) if other.dimensions.max >= max
        self.img = compose(other, over)
      end
    end

    #
    # Writes image to disk
    #
    def image(out)
      splash_start
      splash_composite
      FileUtils.mkdir_p File.dirname(out)
      img.write(out)
    rescue Errno::ENOENT
      YAMG.puts_and_exit("Path not found '#{out}'")
    end
  end
end
