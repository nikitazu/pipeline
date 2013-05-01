require 'thor'
require 'pipeline/http_pipe'
require 'pipeline/zip_seven_pipe'
require 'pipeline/email_pipe'

module Piper
  class CLI < Thor
    
    desc 'http URI FILENAME', 'Downloads file from URI and saves it as FILENAME'
    def http(uri, filename)
      x = Pipeline::HttpPipe.new
      x.source.add uri
      x.config[:filename] = filename
      x.execute
    end
    
    desc 'zip7 PATH', 'Archives file represented by PATH with 7-zip'
    method_option :part_size_mb, :aliases => "-p"
    def zip7(path)
      x = Pipeline::ZipSevenPipe.new
      x.source.add path
      size = options[:part_size_mb]
      if not size.nil?
        x.config[:part_size_mb] = size
      end
      x.execute
    end
    
    desc 'email PATH', 'Sends file represented by PATH via e-mail'
    def email(path)
      x = Pipeline::EmailPipe.new
      x.source.add path
    end
  end
end
