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
      require 'smartshot'
      require 'capybara'
      require 'capybara/poltergeist'
      @name, opts =  *ss
      uri = URI.parse(opts['url'])
      @url = "http://#{uri}"
      @size = opts['size'].split(/\s?,\s?/)
      # @fetcher = Smartshot::Screenshot.new(window_size: @size)
      @fetcher = Screencap::Fetcher.new(@url)

    end

    def work(path)
      # visit(url)
      # page.save_screenshot("#{path}/#{@name}.png")
      # @fetcher.take_screenshot!(url: url, output: "#{path}/#{@name}.png")
      @fetcher.fetch(output: "#{path}/#{@name}.png", width: @size[0], height: @size[1])
      puts Rainbow("SS #{url} #{size}").black
    end
  end

end
