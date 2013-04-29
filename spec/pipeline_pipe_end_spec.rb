require 'pipeline'
require 'pipeline/pipe_end'

describe Pipeline::PipeEnd do
  it 'pipe end max init' do
    x = Pipeline::PipeEnd.new 3
    x.max.should eql(3)
  end
  
  it 'pipe end add one' do
    x = Pipeline::PipeEnd.new 1
    x.add('item').should eql(true)
    x.items.should eql(['item'])
  end
  
  it 'pipe end add some' do
    x = Pipeline::PipeEnd.new 3
    x.add('item 1').should eql(true)
    x.add('item 2').should eql(true)
    x.add('item 3').should eql(true)
    x.items.should eql(['item 1', 'item 2', 'item 3'])
  end
  
  it 'pipe end add too much' do
    x = Pipeline::PipeEnd.new 2
    x.add('item 1').should eql(true)
    x.add('item 2').should eql(true)
    x.add('item 3').should eql(false)
    x.items.should eql(['item 1', 'item 2'])
  end
  
  it 'pipe end clear' do
    x = Pipeline::PipeEnd.new 1
    x.add('item').should eql(true)
    x.items.should eql(['item'])
    x.clear
    x.items.should eql([])
  end
end
