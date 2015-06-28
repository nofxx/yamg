module YAMG
  # Command line interface
  class CLI
    attr_accessor :works, :scope

    def initialize(argv)
      puts
      puts Rainbow('     Y              A               M               G').red
      puts
      if argv.join =~ /debug/
        YAMG.debug = true
        puts Rainbow('!!! DEBUG !!!').red
        argv.delete('debug')
      end
      return YAMG.init if argv.join =~ /init/
      YAMG.load_config # (argv)
      @works = YAMG.config['compile']
      @scope = argv.empty? ? nil : argv.join
    end

    def setup_for(opts)
      case opts
      when Hash then opts
      when String then { 'path' => opts }
      when TrueClass then { 'path' => './export/' }
      else fail
      end
    end

    def compile_media(i, size, setup)
    end

    def compile_icon(i, size, setup)
      folder = setup['icon'] || YAMG.config['icon']['path']
      # Don' use || here, we are after false
      round = setup['rounded']
      round = YAMG.config['icon']['rounded'] if round.nil?
      to = File.join(setup['path'], i)
      Icon.new(folder, size, round).image(to)
      print Rainbow(round ? '(i)' : '[i]').black
      return unless YAMG.debug
      puts Rainbow("Icon    #{size}px -> #{setup['path']}#{i} ").black
    end

    def compile_splash(s, size, setup)
      path = setup['splash'] || YAMG.config['splash']['path']
      background = YAMG.config['splash']['background']
      to = File.join(setup['path'], s)
      Splash.new(path, size, background).image(to)
      print Rainbow('{S}').black
      return unless YAMG.debug
      puts Rainbow("Splash #{size.join('x')}px #{setup['path']}#{s}").black
    end

    def compile_work(template, opts)
      setup = setup_for(opts)

      if (task = YAMG::TEMPLATES[template])
        %w(icon splash media).each do |key|
          next unless (work = task[key])
          work.each do |i, d|
            #Thread.new do # 200% speed up with 8 cores
              send(:"compile_#{key}", i, d, setup)
            #end
          end
        end
      else
        # puts 'Custom job!'
      end
    end

    def compile
      works.select! { |k,_v| k =~ /#{scope}/ } if scope
      puts Rainbow("Tasks: #{works.keys.join(', ')}").yellow
      works.each { |out, opts| compile_work(out, opts) }
    end

    def screenshot
      YAMG.config['screenshots'].each do |ss|
        Thread.new do
          Screenshot.new(ss).work('./export')
          puts Rainbow("[o]SS #{ss[0]} #{ss[1]}").black
        end
      end
    end

    def work!
      time = Time.now
      compile
      screenshot if scope.nil? || scope =~ /ss|shot|screen/
      puts
      puts Rainbow(Thread.list.size.to_s + ' jobs to go').black
      Thread.list.reject { |t| t == Thread.current }.each(&:join)
      puts Rainbow('-' * 59).black
      puts Rainbow("Done compile #{Time.now - time}").red
    end
  end
end
