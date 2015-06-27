require 'yaml'
require 'rainbow'
require 'mini_magick'

require 'yamg/cli'
require 'yamg/icon'
require 'yamg/splash'
require 'yamg/screenshot'

MiniMagick.processor = :gm if ENV['gm']

#
# Yet Another Media Generator
#
module YAMG

  # Load template works
  TEMPLATES = YAML.load_file(
    File.join(File.dirname(__FILE__), 'yamg', 'templates.yaml')
  )

  # def initialize(conf = './.yamg.yml')
  #   load_config(conf)
  # end
  class << self
    attr_accessor :config

    def init
      file = './.yamg.yml'
      if File.exist?(file)
        puts "File exists: '#{file}'";
        exit 1
      end
      puts Rainbow('Creating your configuration').black
      src = File.join(File.dirname(__FILE__), 'yamg', 'yamg.yml')
      FileUtils.cp(src, file)
    end

    def load_config(conf = './.yamg.yml')
      self.config = YAML.load_file(conf).freeze
    rescue Errno::ENOENT
      puts Rainbow('Create config! Run: `yamg init`').red
      exit 1
    end

    def load_images(dir)
      return [dir] unless File.extname(dir).empty?
      Dir["#{dir}/*.png"].map { |f| File.basename(f) }
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
