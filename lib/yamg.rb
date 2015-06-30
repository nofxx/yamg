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
    attr_accessor :config, :debug

    def init
      if File.exist?(CONFIG_FILE)
        puts "File exists: '#{CONFIG_FILE}'"
        exit 1
      end
      src = File.join(File.dirname(__FILE__), 'yamg', 'yamg.yml')
      FileUtils.cp(src, CONFIG_FILE)
      puts_and_exit("Created configuration file '#{CONFIG_FILE}'", :black)
    end

    def load_config(conf = CONFIG_FILE)
      self.config = YAML.load_file(conf).freeze
    rescue Errno::ENOENT
      puts_and_exit('Create config! Run: `yamg init`')
    end

    def load_images(dir)
      return [dir] unless File.extname(dir).empty?
      Dir["#{dir}/*.{svg,png,jpg}"].map { |f| File.basename(f) }
    rescue TypeError
      puts_and_exit("Bad config file path: #{dir}")
    end

    def run(comm)
      puts comm if debug
      system(comm)
    end

    def run_rsvg(src, out, args = nil)
      FileUtils.mkdir_p File.dirname(out)
      run "rsvg-convert #{args} #{src} > #{out}"
    end


    def run_ffmpeg
    end

    def run_imagemagick(comm)
      shell = MiniMagick::Shell.new #(whiny)
      shell.run(comm).strip
    end

    def info(msg, color = :red)
      return unless debug
      puts Rainbow(msg).send(color)
    end

    def puts_and_exit(msg, color = :red)
      puts
      puts Rainbow('---').black
      puts Rainbow(msg).send(color)
      exit color == :red ? 1 : 0
    end
  end
end
