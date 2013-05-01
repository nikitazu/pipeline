require 'pipeline/line'
require 'pipeline/http_pipe'
require 'pipeline/zip_seven_pipe'
require 'pipeline/email_pipe'

describe Pipeline::Line do
  it 'line full connect and execute' do
    line = Pipeline::Line.new
    http = Pipeline::HttpPipe.new
    zip7 = Pipeline::ZipSevenPipe.new
    mail = Pipeline::EmailPipe.new
    
    line.add http
    line.add zip7
    line.add mail
    
    line.source.add "http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download"
    http.config[:filename] = 'readme.txt'
    zip7.config[:part_size_mb] = '1'
    mail.config[:to] = 'nikitazu@gmail.com'
    line.execute
    
    http.result.should eql(:ok)
    zip7.result.should eql(:ok)
    mail.result.should eql(:skip)
    line.result.should eql(:skip)
  end
end
