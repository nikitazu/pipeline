require 'pipeline'
require 'pipeline/pipe'
require 'pipeline/http_pipe'

describe Pipeline::HttpPipe do
  it 'http pipe tenshi.ru' do
    x = Pipeline::HttpPipe.new
    x.source.add "http://tenshi.ru/anime-ost/3x3_Eyes/Chi_no_Maki.Earth_Chapter/01%20-%20One's%20Heart.mp3"
    x.target.add "/Users/nikitazu/tenshi.ru.mp3"
    #x.execute
    #x.result.should eql(:skip)
  end
  
  it 'http pipe sourceforge.net' do
    x = Pipeline::HttpPipe.new
    x.source.add "http://sourceforge.net/projects/mingwbuilds/files/latest/download?source=frontpage&position=9"
    x.target.add "/Users/nikitazu/sourceforge.net.zip"
    #x.execute
    #x.result.should eql(:skip)
  end
end
