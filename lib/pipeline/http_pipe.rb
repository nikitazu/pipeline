require 'net/http'
require 'pipeline/pipe'

module Pipeline
  class HttpPipe < Pipe
    def initialize
      super('HTTP', 1, 1)
      @config[:path] = '/tmp/hclerk/'
    end
    
    def check_before_work
      file = @config[:filename]
      path = @config[:path]
      
      @uri = @source.items[0]
      @save_to = File.join(path, file)
      
      if not File.exists?(path)
        log "creating directory: #{path}"
        Dir.mkdir path
      end
      
      return :ok
    end
    
    def work
      return load(@uri, @save_to)
    end
    
    def check_after_work
      if not File.exists?(@save_to)
        return :fail
      end
      
      @target.add @save_to
      
      return :ok
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
        log "error: #{response.value}"
        return :fail
      end
    end
    
  end
end
