module YAMG
  # Command line interface
  class CLI
    attr_accessor :works

    def initialize(argv)
      puts
      puts Rainbow('     Y              A               M               G').red
      puts
      YAMG.debug = true if argv.join =~ /debug/
      puts Rainbow('!!! DEBUG !!!').red if YAMG.debug
      return YAMG.init if argv.join =~ /init/
      YAMG.load_config # (argv)
      @works = YAMG.config['compile']
    end

    def setup_for(opts)
      case opts
      when Hash then opts
      when String then { 'path' => opts }
      when TrueClass then { 'path' => './export/' }
      else fail
      end
    end

    def compile_icon(i, size, setup)
      folder = setup['icon'] || YAMG.config['icon']['path']
      round = setup['rounded'] || YAMG.config['icon']['rounded']
      to = File.join(setup['path'], i)
      icon = Icon.new(folder, size, setup).image(to)
      print Rainbow('I').black
      return unless YAMG.debug
      puts Rainbow("Icon #{size}px -> #{setup['path']}#{i} ").black
    end

    def compile_splash(s, size, setup)
      path = setup['splash'] || YAMG.config['splash']['path']
      splash = Splash.new(path, size, YAMG.config['splash']['background']).image
      to = File.join(setup['path'], s)
      YAMG.write_out(splash, to)
      print Rainbow('S').black
      return unless YAMG.debug
      puts Rainbow("Splash #{size.join('x')}px #{s} -> #{setup['path']}").black
    end

    def compile_work(scope, opts)
      setup = setup_for(opts)

      if (task = YAMG::TEMPLATES[scope])
      #Thread.new do # 200% speed up with 8 cores
        task['icons'].each { |i, d|  compile_icon(i, d, setup) }
        # task['icons'].each { |i, d| Thread.new { compile_icon(i, d, setup) }}
        # return unless task['splash']
        # task['splash'].each { |s, d| Thread.new { compile_splash(s, d, setup) }}
      #end
      else
        # puts 'Custom job!'
      end
    end

    def compile(scope = nil)
      works.select! {  |w| w =~ scope } if scope
      works.each { |out, opts| compile_work(out, opts) }
      works.select! {  |w| w =~ scope } if scope
      puts Rainbow("Working on #{works.keys.join(', ')}").yellow
    end

    def screenshot
      YAMG.config['screenshots'].each do |ss|
        Thread.new { Screenshot.new(ss).work('./ss') }
      end
    end

    def work!
      time = Time.now
      compile
      screenshot
      puts Rainbow(Thread.list.size.to_s + ' jobs').black
      Thread.list.reject { |t| t == Thread.current }.each(&:join)
      puts Rainbow('-' * 59).black
      puts Rainbow("Done compile #{Time.now - time}").red
    end
  end
end
