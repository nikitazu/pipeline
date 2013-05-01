require 'thor'
require 'pipeline/http_pipe'
require 'pipeline/zip_seven_pipe'
require 'pipeline/email_pipe'
require 'pipeline/line'

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
    
    desc 'email PATH TO', 'Sends file represented by PATH via e-mail to TO'
    def email(path, to)
      x = Pipeline::EmailPipe.new
      x.source.add path
      x.config[:to] = to
      x.execute
    end
    
    desc 'line PATH FILENAME TO', 'Downloads file from URI archives it with 7-zip and sends via e-mail to TO'
    def line(path, filename, to)
      line = Pipeline::Line.new
      line.add Pipeline::HttpPipe.new, { :filename => filename }
      line.add Pipeline::ZipSevenPipe.new, { }
      line.add Pipeline::EmailPipe.new, { :to => to }

      line.source.add path
      line.execute
    end
  end
end
