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
      
      if not File.exists?(EMAIL_LOGINFILE)
        log "error: login file not found #{EMAIL_LOGINFILE}"
        return :fail
      end

      if not File.exists?(EMAIL_PASSFILE)
        log "error: password file not found #{EMAIL_PASSFILE}"
        return :fail
      end
      
      @template.from = File.read(EMAIL_LOGINFILE).strip
      @template.password = File.read(EMAIL_PASSFILE).strip
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

  end
end
