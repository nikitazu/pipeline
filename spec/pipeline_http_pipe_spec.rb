require 'pipeline/http_pipe'

describe Pipeline::HttpPipe do
  it 'http pipe tenshi.ru' do
    x = Pipeline::HttpPipe.new
    x.source.add "http://tenshi.ru/anime-ost/3x3_Eyes/Chi_no_Maki.Earth_Chapter/01%20-%20One's%20Heart.mp3"
    x.config[:filename] = 'tenshi.mp3'
    #x.execute
    #x.result.should eql(:skip)
  end
  
  it 'http pipe sourceforge.net' do
    x = Pipeline::HttpPipe.new
    x.source.add "http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download"
    x.config[:filename] = "readme.txt"
    #x.execute
    #x.result.should eql(:skip)
  end
end
