require 'pipeline/pipe'

module Pipeline
  class Line < Pipe
    
    def initialize
      super('line', 0, 0)
      @pipes = []
      @pipes_hash = {}
    end
    
    def add(pipe, config = {})
      log "adding pipe #{pipe.name} to line"
      @pipes.push pipe
      @pipes_hash[pipe.name] = pipe
      config.each do |key, value|
        pipe.config[key] = value
      end
      
      pipe.add_observer ItemsObserver.new(self)
    end
    
    def pipe(name)
      return @pipes_hash[name]
    end
    
    def work
      if @pipes.empty?
        log 'line is empty'
        return :skip
      end
      
      @source.push_to @pipes[0].source
      
      index = 0
      length = @pipes.length
      @pipes.each do |pipe|
        if index == 0
          log "first pipe is #{pipe.name}"
        elsif index == (length - 1)
          log "last pipe is #{pipe.name}"
        else
          log "next pipe is #{pipe.name}"
        end
          
        pipe.execute
        if pipe.result == :fail
          log "#{pipe.name} failed, breaking line"
          return :fail
        end
        
        if index < (length - 1)
          nextpipe = @pipes[index + 1]
          log "connecting ends [#{pipe.name} => #{nextpipe.name}]"
          pipe.target.push_to nextpipe.source
        end
        
        index += 1
      end
      
      return :ok
    end
    
  end
  
  class ItemsObserver
    def initialize(line)
      @line = line
    end
    
    def update(data)
      @line.changed
      @line.notify_observers data
    end
  end
end
