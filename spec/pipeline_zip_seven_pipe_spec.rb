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
  
  it 'zip 7 sort' do
    items = ['archive.7z.006','archive.7z.007','archive.7z.005','archive.7z.003','archive.7z.004','archive.7z.002','archive.7z.001']
    presorted = ['archive.7z.001','archive.7z.002','archive.7z.003','archive.7z.004','archive.7z.005','archive.7z.006','archive.7z.007']
    sorted = Pipeline::ZipSevenSort.sort(items)
    sorted.should eql(presorted)
  end
end
