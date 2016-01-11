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
    # ICO: 16/32/48
    #
    def initialize(src, size, bg = nil, rounded = false, radius = 9)
      fail 'No source' if src.nil? || src.empty?
      @src = src
      @size  = size
      @rounded = rounded
      @icons = YAMG.load_images(src)
      YAMG.puts_and_exit("No sources in '#{src}'") if icons.empty?
      @choosen = File.join(src, find_closest_gte_icon)
      @radius = radius || 9
      # @dpi = 90
      @bg = bg
    end
    alias_method :rounded?, :rounded

    def find_closest_gte_icon
      proc = ->(x) { x.tr('^0-9', '').to_i }
      return icons.max_by(&proc) if icons.map(&proc).max < size
      icons.min_by do |f|
        n = proc.call(f)
        size > n ? Float::INFINITY : n
      end
    end

    def radius
      Array.new(2, size / @radius).join(',')
    end

    def dimensions
      img.dimensions.join(',')
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
      mask = MiniMagick::Image.open(img.path)
      mask.format 'png'

      mask.combine_options do |m|
        m.alpha 'transparent'
        m.background 'none'
        m.draw "roundrectangle 0,0,#{dimensions},#{radius}"
      end

      overlay = ::MiniMagick::Image.open img.path
      overlay.format 'png'

      overlay.combine_options do |o|
        o.alpha 'transparent'
        o.background 'none'
        o.draw "roundrectangle 0,0,#{dimensions},#{radius}"
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

    def apply_background
      clone = ::MiniMagick::Image.open img.path
      clone.combine_options do |o|
        o.draw 'color 0,0 reset'
        o.fill @bg
      end
      clone.composite(img) { |i| i.compose 'Over' }
    end

    # Just copy the svg, never resize
    def svg!
      fail unless @icons.find { |i| File.extname(i) == 'svg' }
    end

    # ICO!
    def ico!(out)
      temp = ->(s) { "/tmp/#{s}-#{Thread.current.object_id}.png" }
      MiniMagick::Tool::Convert.new do |o|
        o << Icon.new(@src, 16).image(temp.call(16))
        o << Icon.new(@src, 32).image(temp.call(32))
        o << Icon.new(@src, 48).image(temp.call(48))
        o.colors 256
        o << out
      end
    end

    def image(out = nil)
      return svg! if out =~ /svg$/
      return ico!(out) if out =~ /ico$/
      temp = out || "/tmp/#{@choosen.object_id}.png"
      if File.extname(@choosen) =~ /svg/
        pixels = dpi ? "-d #{dpi} -p #{dpi}" : nil
        args = "#{pixels} -w #{size} -h #{size} -f png"
        YAMG.run_rsvg(@choosen, temp, args)
        @img = MiniMagick::Image.open(temp)
        @img.format File.extname(out) if out

      else
        @img = MiniMagick::Image.open(@choosen)
        @img.format File.extname(out) if out
        @img.resize size # "NxN"
      end
      @img = apply_background if @bg
      @img = round if rounded?
      out ? write_out(out) : img
    end

    #
    # Writes image to disk
    #
    def write_out(path = nil)
      return img unless path
      FileUtils.mkdir_p File.dirname(path)
      img.write(path)
      path
    rescue Errno::ENOENT
      puts_and_exit("Path not found '#{path}'")
    end
  end
end
