require 'net/smtp'

module Pipeline
  
  MARKER = 'SOMEUNIQUEMARKER'
  
  class GmailTemplate
    attr_accessor :to
    attr_accessor :from
    attr_accessor :body
    attr_accessor :password
    
    def gmail(attachment, subject)
      mail = Gmail.new
      mail.to = @to
      mail.from = @from
      mail.body = @body
      mail.password = @password
      mail.attachment = attachment
      mail.subject = subject
      
      mail.headers = <<EOF
From: Happy Clerk <#{@from}>
To: #{@to}
Subject: #{subject}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{MARKER}
--#{MARKER}
EOF
      mail.body = <<EOF
Content-Type: text/plain
Content-Transfer-Encoding:8bit
#{@body}
--#{MARKER}
EOF
      return mail
    end
  end
  
  class Gmail
    attr_accessor :to
    attr_accessor :from
    attr_accessor :attachment
    attr_accessor :subject
    attr_accessor :body
    attr_accessor :password
    attr_accessor :headers
    attr_accessor :body
    
    def send
      name = File.basename(@attachment)
      content = [File.read(@attachment)].pack('m') # base64
      attachment = <<EOF
Content-Type: multipart/mixed; name=\"#{name}\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename="#{name}"

#{content}
--#{MARKER}--
EOF
 
      message = @headers + @body + attachment
      smtp = Net::SMTP.new('smtp.gmail.com', 587)
      smtp.enable_starttls
      smtp.start('gmail.com', @from, @password, :login) do |smtp|
        smtp.send_message message, @from, @to
      end
    end
  end
end
