require 'net/http'

module Pipeline
  class HttpPipe < Pipe
    def initialize
      super('HTTP', 1, 1)
    end
    
    def work
      uri = @source.items[0]
      file = @target.items[0]
      
      return load(uri, file)
    end
    
    def load(uri, file)
      log "loading uri #{uri}"
      response = Net::HTTP.get_response(URI(uri))
      
      case response
      when Net::HTTPSuccess then
        File.open(file, 'w') do |f|
          log "writing file #{file}"
          f.write response.body
        end
        return :ok
      when Net::HTTPRedirection then
        redir = response['location']
        log "redirection #{redir}"
        load(redir, file)
        return :ok
      else
        return :fail
      end
    end
    
  end
end
