require 'pipeline'
require 'pipeline/pipe'

describe Pipeline::Pipe do
  it 'pipe init' do
    x = Pipeline::Pipe.new 'pipe', 2, 1
    x.config[:foo] = 'bar'
    x.name.should eql('pipe')
    x.config.should eql({ :foo => 'bar' })
    x.source.max.should eql(2)
    x.target.max.should eql(1)
  end
  
  it 'pipe execute' do
    x = Pipeline::Pipe.new 'pipe', 2, 1
    x.execute
    x.result.should eql(:skip)
  end
end
