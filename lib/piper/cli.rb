require 'thor'
require 'pipeline/pipe'
require 'pipeline/http_pipe'
require 'pipeline/zip_seven_pipe'
require 'pipeline/email_pipe'
require 'pipeline/line'

module Piper
  class CLI < Thor
    
    desc 'http URI', 'Downloads file from URI and saves it on disk'
    method_option :filename, :aliases => '-f'
    method_option :path, :aliases => '-p'
    def http(uri)
      x = Pipeline::HttpPipe.new
      x.add_observer Pipeline::ConsoleLogger.new
      x.source.add uri
      x.config[:filename] = options[:filename]
      path = options[:path]
      if not path.nil?
        x.config[:path] = path
      end
      x.execute
    end
    
    desc 'zip7 PATH', 'Archives file represented by PATH with 7-zip'
    method_option :part_size_mb, :aliases => "-p"
    def zip7(path)
      x = Pipeline::ZipSevenPipe.new
      x.add_observer Pipeline::ConsoleLogger.new
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
      x.add_observer Pipeline::ConsoleLogger.new
      x.source.add path
      x.config[:to] = to
      x.execute
    end
    
    desc 'line URI TO', 'Downloads file from URI archives it with 7-zip and sends via e-mail to TO'
    def line(uri, to)
      line = Pipeline::Line.new
      line.add_observer Pipeline::ConsoleLogger.new
      line.add Pipeline::HttpPipe.new
      line.add Pipeline::ZipSevenPipe.new
      line.add Pipeline::EmailPipe.new, :to => to 

      line.source.add uri
      line.execute
    end
  end
end
