require 'pipeline'
require 'pipeline/pipe'
require 'pipeline/zip_pipe'

describe Pipeline::ZipPipe do
  it 'zip pipe tenshi.ru' do
    x = Pipeline::ZipPipe.new
    x.source.add "/Users/nikitazu/clerk/tenshi.ru.mp3"
    #x.execute
    #x.result.should eql(:skip)
  end
end
