require 'pipeline'
require 'pipeline/pipe'
require 'pipeline/zip_seven_pipe'

describe Pipeline::ZipSevenPipe do
  it 'zip pipe tenshi.ru' do
    x = Pipeline::ZipSevenPipe.new
    x.source.add "tenshi.ru.mp3"
#    x.execute
#    x.result.should eql(:skip)
  end
end
