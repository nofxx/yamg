module YAMG
  #
  # ICONS
  #
  #
  class Icon
    attr_accessor :src, :rounded, :setup

    def initialize(src, rounded = false, setup = nil)
      fail if src.nil? || src.empty?
      @src = src
      @rounded = rounded
      @setup  = setup
      puts Rainbow("Starting in #{src}").white
    end

    def find_closest_gte_icon(size, icons)
      return icons.max_by(&:to_i) if icons.map(&:to_i).max < size
      icons.min_by do |f|
        # n = x.match(/\d+/).to_s.to_i
        n = f.to_i
        size > n ? Float::INFINITY : n
      end
    end

    def convert(from, to, size, rounded)
      puts Rainbow("#{File.basename from} -> #{to} (#{size}px)").black
      image = MiniMagick::Image.open(from)
      image.resize size # "NxN"
      image = round(image) if rounded
      YAMG.write_out(image, to)
    end

    def icon_work(files, out)
      icons = YAMG.load_images(src)
      files.each do |file, size|
        from = File.join(src, find_closest_gte_icon(size, icons))
        to = File.join(out, file)
        convert(from, to, size, rounded)
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
  end
end
