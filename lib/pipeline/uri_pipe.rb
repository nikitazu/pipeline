require 'net/http'
require 'uri'
require 'pipeline/pipe'

module Pipeline
  class UriPipe < Pipe
    def initialize
      super('URI', 1, 3)
      @config[:filename] = nil
      @config[:ensure_safe_filename] = 'yes'
    end
    
    def check_before_work
      @uri = @source.items[0]
      @filename = @config[:filename]
      @ensure_safe_filename = @config[:ensure_safe_filename]
      return :ok
    end
    
    def work
      return follow @uri
    end
    
    def check_after_work
      @target.add @final_uri
      @target.add @filename
      @target.add @content_length
      return :ok
    end
    
    def follow(uri)
      log "following uri #{uri}"
      response = Net::HTTP.get_response(URI(uri))
      
      case response
      when Net::HTTPSuccess then
        @content_length = response.content_length
        log "content length #{@content_length}"
        @final_uri = uri
        @filename = parse_filename uri
        return :ok
      when Net::HTTPRedirection then
        redir = response['location']
        log "redirection #{redir}"
        return follow redir
      else
        log "error: #{response.value}"
        return :fail
      end
    end
    
    def parse_filename(uri)
      parsed_uri = URI.parse uri
      filename = File.basename parsed_uri.path
      filename = URI.unescape(filename)
      
      if @ensure_safe_filename == 'yes'
        filename.gsub! /'/, '_'
        filename.gsub! /\s/, '_'
        filename.gsub! /-/, '_'
        filename.gsub! /_+/, '_'
      end
      
      return filename
    end
  end
end
