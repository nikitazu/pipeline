require 'pipeline/pipe'
require 'pipeline/gmail'

module Pipeline
  
  EMAIL_LOGINFILE = File.expand_path('~/.happy-clerk/email.login')
  EMAIL_PASSFILE = File.expand_path('~/.happy-clerk/email.password')
  
  class EmailPipe < Pipe
    def initialize
      super('E-Mail', 0, 0)
    end
    
    def check_before_work
      @source.items.each do |file|
        if not File.exists?(file)
          log "error: file not found #{file}"
          return :fail
        end
      end
      
      @template = GmailTemplate.new
      @template.to = config[:to]
      
      if @template.to.nil?
        log "error: config parameter [to] is not set"
        return :fail
      end
      
      @template.from = read_from_config_or_file(:login, EMAIL_LOGINFILE)
      if @template.from.nil?
        return :fail
      end
      
      @template.password = read_from_config_or_file(:password, EMAIL_PASSFILE)
      if @template.password.nil?
        return :fail
      end
      
      @template.body = <<EOF
Hello!

Your file is ready.

Best wishes.
--
Happy Clerk
EOF

      return :ok
    end
    
    def work
      length = @source.length
      @source.items.each do |file| 
        gmail = @template.gmail(file, "File: #{File.basename(file)} (of #{length})")
        log "sending file #{file} of #{length}"
        gmail.send
      end
      return :ok
    end
    
    def read_from_config_or_file(key, path)
      value = @config[key]
      
      unless value.nil?
        return value
      end
      
      unless File.exists?(path)
        log "error: config parameter [#{key}] is not set and login file not found #{EMAIL_LOGINFILE}"
        return nil
      end
      
      return File.read(path).strip
    end

  end
end
