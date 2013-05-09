require 'pipeline/uri_pipe'

describe Pipeline::UriPipe do
  it 'uri pipe tenshi.ru' do
    x = Pipeline::UriPipe.new
    x.add_observer Pipeline::ConsoleLogger.new
    x.source.add "http://tenshi.ru/anime-ost/3x3_Eyes/Chi_no_Maki.Earth_Chapter/01%20-%20One's%20Heart.mp3"
    #x.config[:filename] = 'tenshi.mp3'
    x.execute
    x.result.should eql(:ok)
    puts x.target.items
    x.target.items[0].should eql("http://tenshi.ru/anime-ost/3x3_Eyes/Chi_no_Maki.Earth_Chapter/01%20-%20One's%20Heart.mp3")
    x.target.items[1].should eql('01_One_s_Heart.mp3')
    x.target.items[2].should eql(6455296)
  end
  
  it 'uri pipe sourceforge.net' do
    x = Pipeline::UriPipe.new
    x.source.add "http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download"
    x.add_observer Pipeline::ConsoleLogger.new
    #x.config[:filename] = "readme.txt"
    x.execute
    x.result.should eql(:ok)
    x.target.items[0].should_not eql("http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download")
    x.target.items[1].should eql('readme.txt')
    x.target.items[2].should eql(2263)
  end
end
