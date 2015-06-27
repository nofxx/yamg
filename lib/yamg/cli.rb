module YAMG
  # Command line interface
  class CLI
    attr_accessor :works

    def initialize(argv)
      puts
      puts Rainbow('     Y              A               M               G').red
      puts

      return YAMG.init if argv.join =~ /init/
      YAMG.load_config # (argv)
      @works = YAMG.config['compile']
      compile
      screenshot
    end

    def setup_for(opts)
      case opts
      when Hash then opts
      when String then { 'path' => opts }
      when TrueClass then { 'path' => './media' }
      else fail
      end
    end

    def compile_work(scope, opts)
      puts Rainbow("Working on :#{scope}").yellow
      setup = setup_for(opts)

      if (task = YAMG::TEMPLATES[scope])
        Thread.new do # 200% speed up with 8 cores
          folder = setup['icon'] || YAMG.config['icon']['path']
          round = setup['rounded'] || YAMG.config['icon']['rounded']
          Icon.new(folder, round, setup).icon_work(task['icons'], setup['path'])
          next unless task['splash']
          Splash.new(YAMG.config['splash'])
            .splash_work(task['splash'], setup['path'])
        end
      else
        puts 'Custom job!'
      end
    end

    def compile(scope = nil)
      time = Time.now
      works.select! {  |w| w =~ scope } if scope
      works.each { |out, opts| compile_work(out, opts) }
      Thread.list.reject { |t| t == Thread.current }.each(&:join)
      puts Rainbow("Done compile #{Time.now - time}").red
    end

    def screenshot
    end
  end
end
