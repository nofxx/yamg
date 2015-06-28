module YAMG
  #
  # ICONS
  #
  #
  class Icon
    attr_accessor :src, :size, :dpi, :rounded, :icons

    def initialize(src, size, rounded = false)
      fail if src.nil? || src.empty?
      @src = src
      @size  = size
      @rounded = rounded
      @icons = YAMG.load_images(src)
      YAMG.puts_and_exit("No sources in '#{src}'") if icons.empty?
      @path = File.join(src, find_closest_gte_icon)
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

    def image(out)
      if File.extname(@path) =~ /svg/
        pixels = dpi ? "-d #{dpi} -p #{dpi}" : nil
        args = "#{pixels} -w #{size} -h #{size} -f png"
        YAMG.run_rsvg(@path, out, args)
        img = MiniMagick::Image.open(out)
      else
        img = MiniMagick::Image.open(@path)
        img.resize size # "NxN"
        write_out(img, out)
      end
      write_out(round(img), out) if rounded?
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
    def round(img, r = 14)
      size = img.dimensions.join(',')
      r = img.dimensions.max / r
      radius = [r, r].join(',')

      mask = MiniMagick::Image.open(img.path)
      mask.format 'png'

      mask.combine_options do |m|
        m.alpha 'transparent'
        m.background 'none'
        m.draw "roundrectangle 0,0,#{size},#{radius}"
      end

      overlay = ::MiniMagick::Image.open img.path
      overlay.format 'png'

      overlay.combine_options do |o|
        o.alpha 'transparent'
        o.background 'none'
        o.draw "roundrectangle 0,0,#{size},#{radius}"
      end

      masked = img.composite(mask, 'png') do |i|
        i.alpha 'set'
        i.compose 'DstIn'
      end

      masked.composite(overlay, 'png') do |i|
        i.compose 'Over'
      end
      masked
    end

    #
    # Writes image to disk
    #
    def write_out(img, out)
      FileUtils.mkdir_p File.dirname(out)
      img.write(out)
    rescue Errno::ENOENT
      puts_and_exit("Path not found '#{out}'")
    end
  end
end
