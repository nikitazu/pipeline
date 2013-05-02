require 'net/http'
require 'uri'
require 'pipeline/pipe'

module Pipeline
  class HttpPipe < Pipe
    def initialize
      super('HTTP', 1, 1)
      @config[:path] = '/tmp/hclerk/'
    end
    
    def check_before_work
      @path = @config[:path]
      @uri = @source.items[0]
      
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
        parse_save_to uri, path
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
    
    def parse_save_to(uri, path)
      filename = @config[:filename]
      if filename.nil?
        parsed_uri = URI.parse uri
        filename = File.basename parsed_uri.path
      end
      @save_to = File.join path, URI.unescape(filename)
    end
    
    def save_file(response)
      File.open(@save_to, 'w') do |f|
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
