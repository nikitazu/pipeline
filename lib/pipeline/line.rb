require 'pipeline/pipe'

module Pipeline
  class Line < Pipe
    
    def initialize
      super('line', 0, 0)
      @pipes = []
    end
    
    def add(pipe)
      log "adding pipe #{pipe.name} to line"
      @pipes.push pipe
    end
    
    def work
      if @pipes.empty?
        log 'line is empty'
        return :skip
      end
      
      first_pipe = @pipes[0]
      @source.items.each do |src|
        first_pipe.source.add src
      end
      
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
          
          pipe.target.items.each { |target| nextpipe.source.add target }
        end
        
        index += 1
      end
      
      return :ok
    end
    
  end
end
