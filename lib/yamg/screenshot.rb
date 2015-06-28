require 'screencap'
# require 'smartshot'

module YAMG
  #
  # Screenshot from multiple providers
  #
  class Screenshot
    attr_accessor :url, :size, :command

    # Uses PhantomJS
    def initialize(ss)
      @name, opts =  *ss
      fail 'No screen size provided' unless opts['size']
      uri = URI.parse(opts['url'])
      @url = "http://#{uri}"
      @size = opts['size']
      @size = @size.split(/\s?,\s?/) if @size.respond_to?(:split)
      # @fetcher = Smartshot::Screenshot.new(window_size: @size)
      @fetcher = Screencap::Fetcher.new(@url)
    end

    def android
      # adb -e shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > screen.png
    end

    # Take the screenshot
    # Do we need pixel depth??
    def work(path)
      # visit(url)
      # page.save_screenshot("#{path}/#{@name}.png")
      # @fetcher.take_screenshot!(url: url, output: "#{path}/#{@name}.png")
      @fetcher.fetch(output: "#{path}/#{@name}.png", width: @size[0], height: @size[1])
    end
  end
end
