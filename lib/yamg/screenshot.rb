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
      @dpi = opts['dpi']
      @fetcher = Screencap::Fetcher.new(@url)
    end

    def android
      # adb -e shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > screen.png
    end

    # Take the screenshot
    # Do we need pixel depth??
    def work(path)
      out = "#{path}/#{@name}.png"
      @fetcher.fetch(output: out, width: @size[0], height: @size[1], dpi: @dpi)
    end
  end
end
