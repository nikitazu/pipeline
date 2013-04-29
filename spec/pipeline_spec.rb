require 'pipeline'
require 'pipeline/line'

describe Pipeline::Line do
  it 'test is ok' do
    Pipeline::Line.test().should eql("ok")
  end
end
