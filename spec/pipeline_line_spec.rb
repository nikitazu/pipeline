require 'pipeline/line'
require 'pipeline/http_pipe'
require 'pipeline/zip_seven_pipe'
require 'pipeline/email_pipe'

describe Pipeline::Line do
  it 'line full connect and execute' do
    line = Pipeline::Line.new
    
    line.add Pipeline::HttpPipe.new, :filename => 'readme.txt' 
    line.add Pipeline::ZipSevenPipe.new, :part_size_mb => '1' 
    line.add Pipeline::EmailPipe.new, :to => 'nikitazu@gmail.com' 
    
    line.source.add "http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download"
    line.execute
    
    line.result.should eql(:skip)
  end
end
