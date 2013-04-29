module Pipeline
  class PipeEnd
    
    attr_reader :max
    
    def initialize(max)
      @items = []
      @max = max
    end
    
    def add(value)
      if @max > 0 and @items.length == @max
        return false
      end
      
      @items.push value
      return true
    end
    
    def clear
      @items = []
    end
    
    def items
      @items.map { |x| x }
    end
  end
end
