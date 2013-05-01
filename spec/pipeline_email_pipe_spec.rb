require 'pipeline/email_pipe'

describe Pipeline::EmailPipe do
  it 'email pipe send' do
    x = Pipeline::EmailPipe.new
#    x.source.add "/tmp/hclerk/air.mp3.7z.d/air.mp3.7z.001"
#    x.source.add "/tmp/hclerk/air.mp3.7z.d/air.mp3.7z.002"
    x.source.add '/tmp/hclerk/readme.txt'
    x.config[:to] = 'nikitazu@gmail.com'
#    x.execute
#    x.result.should eql(:skip)
  end
end
