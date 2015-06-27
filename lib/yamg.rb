require 'yaml'
require 'rainbow'
require 'screencap'
require 'mini_magick'

MiniMagick.processor = :gm if ENV['gm']

#
# Yet Another Media Generator
#
module YAMG
  autoload :CLI, 'yamg/cli'
  autoload :Icon, 'yamg/icon'
  autoload :Splash, 'yamg/splash'
  autoload :Screenshot, 'yamg/screenshot'

  CONFIG_FILE = './.yamg.yml'
  # Load template works
  TEMPLATES = YAML.load_file(
    File.join(File.dirname(__FILE__), 'yamg', 'templates.yaml')
  )

  class << self
    attr_accessor :config

    def init
      if File.exist?(CONFIG_FILE)
        puts "File exists: '#{CONFIG_FILE}'"
        exit 1
      end
      src = File.join(File.dirname(__FILE__), 'yamg', 'yamg.yml')
      FileUtils.cp(src, CONFIG_FILE)
      puts_and_exit("Created configuration file #{CONFIG_FILE}", :black)
    end

    def load_config(conf = CONFIG_FILE)
      self.config = YAML.load_file(conf).freeze
    rescue Errno::ENOENT
      puts_and_exit('Create config! Run: `yamg init`')
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
      puts_and_exit("Path not found '#{path}'")
    end

    def puts_and_exit(msg, color = :red)
      puts Rainbow(msg).send(color)
      exit color == :red ? 1 : 0
    end
  end
end
