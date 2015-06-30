module YAMG
  #
  # ICONS
  #
  #
  class Icon
    attr_accessor :src, :size, :dpi, :rounded, :radius, :icons, :img

    #
    # Icon
    #
    # Icon.new(src, size, rounded).image
    # Image class
    # Icon.new(src, size, rounded).image('.path.ext')
    # Export image
    #
    def initialize(src, size, rounded = false)
      fail if src.nil? || src.empty?
      @src = src
      @size  = size
      @rounded = rounded
      @icons = YAMG.load_images(src)
      YAMG.puts_and_exit("No sources in '#{src}'") if icons.empty?
      @choosen = File.join(src, find_closest_gte_icon)
      @dpi = 90
    end
    alias_method :rounded?, :rounded

    def find_closest_gte_icon
      return icons.max_by(&:to_i) if icons.map(&:to_i).max < size
      icons.min_by do |f|
        # n = x.match(/\d+/).to_s.to_i
        n = f.to_i
        size > n ? Float::INFINITY : n
      end
    end


    #
    # Maybe this can be smaller, terminal equivalent:
    # convert
    # -size 512x512 xc:none
    # -draw "roundrectangle 0,0,512,512,55,55" mask.png
    # convert icon.png
    # -matte mask.png
    # -compose DstIn
    # -composite picture_with_rounded_corners.png
    # https://gist.github.com/artemave/c20e7450af866f5e7735
    def round(r = 14)
      s = img.dimensions.join(',')
      r = img.dimensions.max / r
      radius = [r, r].join(',')

      mask = MiniMagick::Image.open(img.path)
      mask.format 'png'

      mask.combine_options do |m|
        m.alpha 'transparent'
        m.background 'none'
        m.draw "roundrectangle 0,0,#{s},#{radius}"
      end

      overlay = ::MiniMagick::Image.open img.path
      overlay.format 'png'

      overlay.combine_options do |o|
        o.alpha 'transparent'
        o.background 'none'
        o.draw "roundrectangle 0,0,#{s},#{radius}"
      end

      img.composite(mask, 'png') do |i|
        i.alpha 'set'
        i.compose 'DstIn'
      end.composite(overlay, 'png') do |i|
        i.compose 'Over'
      end
    end

    def image(out = nil)
      temp = out || "/tmp/#{@choosen.object_id}.png"
      if File.extname(@choosen) =~ /svg/
        pixels = dpi ? "-d #{dpi} -p #{dpi}" : nil
        args = "#{pixels} -w #{size} -h #{size} -f png"
        YAMG.run_rsvg(@choosen, temp, args)
        @img = MiniMagick::Image.open(temp)
      else
        @img = MiniMagick::Image.open(@choosen)
        @img.resize size # "NxN"
      end
      @img = round if rounded?
      write_out(out)
    end

    #
    # Writes image to disk
    #
    def write_out(path = nil)
      return img unless path
      FileUtils.mkdir_p File.dirname(path)
      img.write(path)
    rescue Errno::ENOENT
      puts_and_exit("Path not found '#{path}'")
    end
  end
end
