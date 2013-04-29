require 'pipeline'
require 'pipeline/pipe'

describe Pipeline::Pipe do
  it 'pipe init' do
    x = Pipeline::Pipe.new 'pipe', { :foo => 'bar' }, 2, 1
    x.name.should eql('pipe')
    x.config.should eql({ :foo => 'bar' })
    x.source.max.should eql(2)
    x.target.max.should eql(1)
  end
end
