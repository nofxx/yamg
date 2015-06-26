require 'yaml'
require 'rainbow'
require 'mini_magick'

MiniMagick.processor = :gm if ENV['gm']

#
# Yet Another Media Generator
#
class YAMG
  attr_accessor :config

  TEMPLATES = {

    #
    # Android Cordova/Phonegap
    #
    android: {
      # TODO: check if we really need this duplication on android
      icons: {
        'res/drawable/icon.png' => 96,
        'res/drawable-ldpi/icon.png' => 36,
        'res/drawable-mdpi/icon.png' => 48,
        'res/drawable-hdpi/icon.png' => 72,
        'res/drawable-xhdpi/icon.png' => 96,
        'res/drawable-xxhdpi/icon.png' => 256,
        'bin/res/drawable/icon.png' => 96,
        'bin/res/drawable-ldpi/icon.png' => 36,
        'bin/res/drawable-mdpi/icon.png' => 48,
        'bin/res/drawable-hdpi/icon.png' => 72,
        'bin/res/drawable-xhdpi/icon.png' => 96,
        'ant-build/res/drawable/icon.png' => 96,
        'ant-build/res/drawable-ldpi/icon.png' => 36,
        'ant-build/res/drawable-mdpi/icon.png' => 48,
        'ant-build/res/drawable-hdpi/icon.png' => 72,
        'ant-build/res/drawable-xhdpi/icon.png' => 96
      },
      splash: {
        'res/drawable-port-ldpi/screen.png'  => [200, 320],
        'res/drawable-port-mdpi/screen.png'  => [320, 480],
        'res/drawable-port-hdpi/screen.png'  => [480, 800],
        'res/drawable-port-xhdpi/screen.png' => [720, 1280],
        'res/drawable-land-ldpi/screen.png'  => [320, 200],
        'res/drawable-land-mdpi/screen.png'  => [480, 320],
        'res/drawable-land-hdpi/screen.png'  => [800, 480],
        'res/drawable-land-xhdpi/screen.png' => [1280, 720],
        'bin/res/drawable-port-ldpi/screen.png'  => [200, 320],
        'bin/res/drawable-port-mdpi/screen.png'  => [320, 480],
        'bin/res/drawable-port-hdpi/screen.png'  => [480, 800],
        'bin/res/drawable-port-xhdpi/screen.png' => [720, 1280],
        'bin/res/drawable-land-ldpi/screen.png'  => [320, 200],
        'bin/res/drawable-land-mdpi/screen.png'  => [480, 320],
        'bin/res/drawable-land-hdpi/screen.png'  => [800, 480],
        'bin/res/drawable-land-xhdpi/screen.png' => [1280, 720],
        'ant-build/res/drawable-port-ldpi/screen.png'  => [200, 320],
        'ant-build/res/drawable-port-mdpi/screen.png'  => [320, 480],
        'ant-build/res/drawable-port-hdpi/screen.png'  => [480, 800],
        'ant-build/res/drawable-port-xhdpi/screen.png' => [720, 1280],
        'ant-build/res/drawable-land-ldpi/screen.png'  => [320, 200],
        'ant-build/res/drawable-land-mdpi/screen.png'  => [480, 320],
        'ant-build/res/drawable-land-hdpi/screen.png'  => [800, 480],
        'ant-build/res/drawable-land-xhdpi/screen.png' => [1280, 720]
      }
    },

    #
    # iOS cordova/phonegap
    #
    ios: {
      icons: {
        'Resources/icons/icon.png'       => 57,
        'Resources/icons/icon@2x.png'    => 114,
        'Resources/icons/icon-40.png'    => 40,
        'Resources/icons/icon-40@2x.png' => 80,
        'Resources/icons/icon-40@3x.png' => 120,
        'Resources/icons/icon-50.png'    => 50,
        'Resources/icons/icon-50@2x.png' => 100,
        'Resources/icons/icon-60.png'    => 60,
        'Resources/icons/icon-60@2x.png' => 120,
        'Resources/icons/icon-60@3x.png' => 180,
        'Resources/icons/icon-72.png'    => 72,
        'Resources/icons/icon-72@2x.png' => 144,
        'Resources/icons/icon-76.png'    => 76,
        'Resources/icons/icon-76@2x.png' => 152,
        'Resources/icons/icon-120.png'   => 120,
        'Resources/icons/icon-small.png' => 29,
        'Resources/icons/icon-small@2x.png' => 58,
        'Resources/icons/icon-small@3x.png' => 87
      },
      splash: {
        'Resources/splash/Default~iphone.png'            => [320, 480],
        'Resources/splash/Default@2x~iphone.png'         => [640, 960],
        'Resources/splash/Default-Landscape@2x~ipad.png' => [2048, 1536],
        'Resources/splash/Default-Landscape~ipad.png'    => [1024, 768],
        'Resources/splash/Default-Portrait@2x~ipad.png'  => [1536, 2048],
        'Resources/splash/Default-Portrait~ipad.png'     => [768, 1024],
        'Resources/splash/Default-568h@2x~iphone.png'    => [640, 1136],
        'Resources/splash/Default-667h.png'              => [750, 1344],
        'Resources/splash/Default-736h.png'              => [1242, 2208],
        'Resources/splash/Default-Landscape-736h.png'    => [2208, 1242]
      }
    },

    #
    # Phonegap www/res/
    #
    phonegap: {
      icon: {
        'icon/android/icon-36-ldpi.png'  => 36,
        'icon/android/icon-48-mdpi.png'  => 48,
        'icon/android/icon-72-hdpi.png'  => 72,
        'icon/android/icon-96-xhdpi.png' => 96,
        'icon/blackberry/icon-80.png' => 80,
        'icon/ios/icon-57.png'    => 57,
        'icon/ios/icon-57-2x.png' => 114,
        'icon/ios/icon-72.png'    => 72,
        'icon/webos/icon-64.png'  => 64,
        'icon/windows-phone/icon-173-tile.png' => 173,
        'icon/windows-phone/icon-62-tile.png' => 62,
        'icon/windows-phone/icon-48.png' => 48
      },
      splash: {
        'screen/android/screen-ldpi-landscape.png'  => [200, 320],
        'screen/android/screen-mdpi-landscape.png'  => [320, 480],
        'screen/android/screen-hdpi-landscape.png'  => [480, 800],
        'screen/android/screen-xhdpi-landscape.png' => [720, 1280],
        'screen/android/screen-ldpi-portrait.png'   => [320, 200],
        'screen/android/screen-mdpi-portrait.png'   => [480, 320],
        'screen/android/screen-hdpi-portrait.png'   => [800, 480],
        'screen/android/screen-xhdpi-portrait.png'  => [1280, 720],
        'screen/blackberry/screen-225'                 => [225],
        'screen/ios/screen-ipad-landscape-2x.png'         => [2048, 1536],
        'screen/ios/screen-ipad-landscape.png'            => [1024, 768],
        'screen/ios/screen-ipad-portrait-2x.png'          => [1536, 2048],
        'screen/ios/screen-ipad-portrait.png'             => [768, 1024],
        'screen/ios/screen-iphone-landscape.png'          => [480, 320],
        'screen/ios/screen-iphone-landscape-2x.png'       => [960, 640],
        'screen/ios/screen-iphone-portrait-2x.png'        => [640, 960],
        'screen/ios/screen-iphone-portrait-568h-2x.png'   => [640, 1136],
        'screen/ios/screen-iphone-portrait.png'           => [320, 480],
        'screen/ios/screen-iDefault~iphone.png'           => [320, 480],
        'screen/ios/screen-iDefault-667h.png'             => [750, 1344],
        'screen/ios/screen-iDefault-736h.png'             => [1242, 2208],
        'screen/ios/screen-iDefault-Landscape-736h.png'   => [2208, 1242],
        'screen/windows-phone/screen-portrait.jpg'        => [720, 1280]
      }
    },

    #
    # WWW
    #
    web: {
      icons: {
        'icon.png' => 256
      },
      media: {
        'media.png' => 256
      }
    },

    rails: {
      icons: {
        'public/favicon.png' => 16,
        'public/favicon.ico' => 16,
        'public/icon.png' => 512,
        'app/assets/images/icon.png' => 512,
        'app/assets/images/favicon.png' => 16
      },
      media: {
        'public/logo.png' => 512
      }
    },

    twitter: {
      icons: {
        'icon.png' => 256
      }
    },

    #
    # Play Store
    #
    google: {
      icons: {
        'icon.png' => 512,
        'icon1024.png' => 1024, # [1024, 500]
        '180.png' => 180,  # 180, 120
      },
      splash: {
        'splash.png' => [1024, 768]
      }
    },

    #
    # App Store
    #
    apple: {
      icons: {
        'icon.png' => 1024,
        'icon16.png' => 16
      },
      splash: {
        'splash.png' => [1024, 768]
      }
    },

    facebook: {
      icons: {
        'icon.png' => 1024,
        'icon16.png' => 16
      },
      splash: {
        'splash.png' => [1024, 768]
      }
    }
  }

  def initialize
    load_config
  end

  def load_config
    self.config = YAML.load_file('./.yamg.yml').freeze
  rescue Errno::ENOENT
    puts 'Create config!'
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

    if (t = TEMPLATES[scope.to_sym])
      Thread.new do # 200% speed up with 8 cores
        icon_work(t[:icons], setup)
        splash_work(t[:splash], setup) if t[:splash]
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
