require 'net/http'
require 'uri'
require 'pipeline/pipe'

module Pipeline
  class HttpPipe < Pipe
    def initialize
      super('HTTP', 3, 1)
      @config[:path] = '/tmp/hclerk/'
    end
    
    def check_before_work
      @path           = @config[:path]
      @uri            = @source.items[0]
      @filename       = @source.items[1]
      #@content_length = @source.items[2]
      
      if @uri.nil?
        log "fail: source uri is not set"
        return :fail
      end
      
      if @filename.nil?
        log "fail: source filename is not set"
        return :fail
      end
      
      if not File.exists?(@path)
        log "creating directory: #{@path}"
        Dir.mkdir @path
      end
      
      return :ok
    end
    
    def work
      return load(@uri, @path)
    end
    
    def check_after_work
      if not File.exists?(@save_to)
        return :fail
      end
      
      @target.add @save_to
      
      return :ok
    end
    
    
    def load(uri, path)
      log "loading uri #{uri}"
      response = Net::HTTP.get_response(URI(uri))
      
      case response
      when Net::HTTPSuccess then
        log "content length #{response.content_length}"
        @save_to = File.join path, @filename
        save_file response
        return :ok
      when Net::HTTPRedirection then
        redir = response['location']
        log "redirection #{redir}"
        load redir, path
        return :ok
      else
        log "error: #{response.value}"
        return :fail
      end
    end
    
    def save_file(response)
      File.open(@save_to, 'wb') do |f|
        log "writing file #{@save_to}"
        f.write response.body
      end
    end
    
    def log_headers(response)
      response.each do |hkey, hval|
        log "header: #{hkey}=#{hval}"
      end
    end
    
  end
end
