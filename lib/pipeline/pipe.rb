require 'pipeline/pipe_end'

module Pipeline
  class Pipe
    attr_reader :name
    attr_reader :source
    attr_reader :target
    attr_reader :result # :skip :fail :ok
    attr_reader :config
    
    def initialize(name, source_max, target_max)
      @name = name
      @config = {}
      @source = PipeEnd.new source_max
      @target = PipeEnd.new target_max
    end
    
    def execute
      log 'execute'
      log @config
      
      log 'check before work...'
      @result = check_before_work()
      log @result
      if @result == :fail
        return
      end
      
      log 'doing work...'
      @result = work()
      log @result
      if @result == :fail
        return
      end
      
      log 'check after work...'
      @result = check_after_work()
      log @result
      if @result == :fail
        return
      end
      
      log 'execute done'
    end
    
    def check_before_work
      return :skip
    end
    
    def work
      return :skip
    end
    
    def check_after_work
      return :skip
    end
    
    def log(message)
      puts "#{name}: #{message}"
    end
  end
end
