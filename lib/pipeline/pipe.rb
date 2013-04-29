module Pipeline
  class Pipe
    attr_reader :name
    attr_reader :source
    attr_reader :target
    attr_reader :result
    attr_reader :config
    
    def initialize(name, config, source_max, target_max)
      @name = name
      @config = config
      @source = PipeEnd.new source_max
      @target = PipeEnd.new target_max
    end
  end
end
