module YAMG
  #
  # Srcreenshot from multiple providers
  #
  class Screenshot
    # Uses PhantomJS
    def initialize(url, size, opts)
      @url = url
      @size = size
      @opts = opts
    end

    def work
    end
  end
end
