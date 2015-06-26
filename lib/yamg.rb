require 'yaml'
require 'rainbow'
require 'mini_magick'

MiniMagick.processor = :gm if ENV['gm']

#
# Yet Another Media Generator
#
class YAMG
  attr_accessor :config

  TEMPLATES = YAML.load_file(
    File.join(File.dirname(__FILE__), 'yamg', 'templates.yaml')
  )

  def initialize(conf = './.yamg.yml')
    load_config(conf)
  end

  def load_config(conf)
    self.config = YAML.load_file(conf).freeze
  rescue Errno::ENOENT
    puts Rainbow('Create config!').red
    exit 1
  end

  def setup_for(opts)
    case opts
    when Hash then opts
    when String then { 'path' => opts }
    when TrueClass then { 'path' => './media' }
    else fail
    end
  end

  #
  # Writes image to disk
  #
  def write_out(img, path)
    img.format File.extname(path)
    FileUtils.mkdir_p File.dirname(path)
    img.write(path)
  rescue Errno::ENOENT
    puts
    puts Rainbow("Path not found '#{path}'").red
    exit 1
  end

  def compile_work(scope, opts)
    puts Rainbow("Working on #{scope}'").blue
    setup = setup_for(opts)

    if (t = TEMPLATES[scope])
      Thread.new do # 200% speed up with 8 cores
        icon_work(t['icons'], setup)
        splash_work(t['splash'], setup) if t['splash']
      end
    else
      puts 'Custom job!'
    end
  end

  def compile(scope = nil)
    time = Time.now
    works = config['compile']
    works.select! {  |w| w =~ scope } if scope
    works.each { |out, opts| compile_work(out, opts) }
    Thread.list.reject { |t| t == Thread.current }.each(&:join)
    puts Rainbow("Done compile #{Time.now - time}").red
  end

  #
  #
  # ICONS
  #
  #
  def load_icons(path)
    return [path] unless File.extname(path).empty?
    Dir["#{path}/*.png"].map { |f| File.basename(f) }
  end

  def find_closest_gte_icon(size, icons)
    return icons.max_by(&:to_i) if icons.map(&:to_i).max < size
    icons.min_by do |f|
      # n = x.match(/\d+/).to_s.to_i
      n = f.to_i
      size > n ? Float::INFINITY : n
    end
  end

  def icon_work(files, setup)
    path = setup['icon'] || config['icon']['path']
    rounded = setup['rounded'] || config['icon']['rounded']
    icons = load_icons(path)
    puts Rainbow("Starting in #{path} with #{icons} | #{setup}").blue
    files.each do |file, size|
      from = File.join(path, find_closest_gte_icon(size, icons))
      to = File.join(setup['path'], file)
      puts "#{File.basename from} -> #{to} (#{size}px)"
      image = MiniMagick::Image.open(from)
      image.resize size # "NxN"
      image = round(image) if rounded
      write_out(image, to)
    end
  end

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

    # convert
    # -size 512x512 xc:none
    # -draw "roundrectangle 0,0,512,512,55,55" mask.png
    # convert icon.png
    # -matte mask.png
    # -compose DstIn
    # -composite picture_with_rounded_corners.png
  end

  #
  #
  # SPLASH
  #
  #
  def splash_center(path, size, bg = config['splash']['background'])
    icon_size = size.max / 4
    image = MiniMagick::Image.open(path)
    image.resize icon_size if image.dimensions.max >= icon_size
    image.background bg if bg
    image.combine_options do |o|
      o.gravity 'center'
      o.extent size.join('x') # "WxH"
    end
  end

  def splash_composite(base, icons)
    max = base.dimensions.min / 9
    icons.reduce(base) do |img, over|
      oimg = MiniMagick::Image.open(File.join(config['splash']['path'], over))
      oimg.resize(max) if oimg.dimensions.max >= max
      img.composite(oimg) do |o|
        o.compose 'Over'
        o.gravity File.basename(over, '.*')
        o.geometry '+40%+40%'
      end
    end
  end

  def splash_work(screens, setup)
    path = config['splash']['path']
    icons = load_icons(path)
    center = icons.find { |i| i =~ /center/ }
    icons.delete(center)

    puts Rainbow("Starting splashes | #{setup}").blue
    screens.each do |file, size|
      to = File.join(setup['path'], file)
      image = splash_center(File.join(path, center), size)
      write_out(splash_composite(image, icons), to)
    end
  end

  def screenshot
    puts 'SS'
  end
end

#     },
#     "customImages": [
#         {
#             "width": 120,
#             "height": 120,
#             "path": "../Media/custom",
#             "filename": "outputFilename.png",
#             "source": {
#                 "filename": "image.png",
#                 "background": "fff6d5"
#             }
#         }
#     ],
#     "screenshots": [
#         {
#             "url": "http://notabe.com",
#             "name": "homepage"
#         }
#     ]
# }
