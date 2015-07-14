module YAMG
  # Command line interface
  class CLI
    attr_accessor :works, :scope

    def initialize(argv = {})
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
      when Hash then { 'path' => './export/' }.merge(opts)
      when String then { 'path' => opts }
      when TrueClass then { 'path' => './export/' }
      else fail
      end
    end

    def home_for(asset, setup)
      path = setup['path']
      FileUtils.mkdir_p path unless File.exist?(path)
      File.join(path, asset)
    end

    def compile_screenshots(ss, size, setup)
      return unless YAMG.config['screenshot'].respond_to?(:[])
      fail 'No url provided' unless (url = YAMG.config['screenshot']['url'])
      Screenshot.new(ss, 'size' => size, 'url' => url).work(setup['path'])
      puts Rainbow("[o]SS #{ss}").black
    end

    def compile_media(i, size, setup)
    end

    def compile_icon(i, size, setup)
      folder = setup['icon'] || YAMG.config['icon']['path']
      # Don' use || here, we are after false
      bg = setup['bg'] || setup['background']
      round = setup['rounded']
      round = YAMG.config['icon']['rounded'] if round.nil?
      radius = setup['radius']
      Icon.new(folder, size, bg, round, radius).image(home_for(i, setup))
      print Rainbow(round ? '(i)' : '[i]').black
      YAMG.info("Icon    #{size}px -> #{setup['path']}#{i} ", :black)
    end

    def compile_splash(s, size, setup)
      path = setup['splash'] || YAMG.config['splash']['path']
      background = YAMG.config['splash']['background']
      Splash.new(path, size, background).image(home_for(s, setup))
      print Rainbow('{S}').black
      YAMG.info("Splash #{size.join('x')}px #{setup['path']}#{s}", :black)
    end

    def compile_docs(opts)
      out = opts['path']
      %w( manifest.json browserconfig.xml ).each do |doc|
        next if File.exist?(out)
        puts Rainbow("{DOCS} #{out}/#{doc} created. Please review.").red
        src = File.expand_path("assets/#{doc}", File.dirname(__FILE__))
        FileUtils.cp(src, out)
      end
    end

    def compile_work(job, opts)
      task = YAMG::TEMPLATES[job] || (works[job] && works[job]['export'])
      %w(icon logo splash media screenshots).each do |subtask|
        next unless (work = task[subtask])

        work.each do |asset, size|
          Thread.new do # 500% speed up with 8 cores
            send(:"compile_#{subtask}", asset, size, setup_for(opts))
          end
        end
      end
      compile_docs(opts) if task['docs']
    end

    def compile
      works.select! { |k, _v| k =~ /#{scope}/ } if scope
      puts Rainbow("Tasks: #{works.keys.join(', ')}").yellow
      works.each { |out, opts| compile_work(out, opts) }
    end

    def screenshot
      return unless YAMG.config['screenshots'].respond_to?(:each)
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
      puts Rainbow("\n" + '-' * 59).black
      puts Rainbow("Done compile #{(Time.now - time).to_i}s").red
    end
  end
end
