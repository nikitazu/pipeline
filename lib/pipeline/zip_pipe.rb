require 'zip/zip'

module Pipeline
  class ZipPipe < Pipe
    def initialize
      super('ZIP', 1, 0)
    end
    
    def work
      file = @source.items[0]
      archive = "#{file}.zip"
      entry = file.split('/')[-1]
      
      log "creating archive #{archive}"
      Zip::ZipOutputStream.open(archive) do |zos|
        log "creating entry #{entry}"
        zos.put_next_entry entry
        File.open(file, 'r') do |f|
          log "reading file #{file}"
          zos.puts f.read
        end
      end
      
      log "splitting archive #{archive}"
      volumes = Zip::ZipFile.split(archive, 4 * 1024 * 1024)
      log "resulting volumes are #{volumes}"
      
      return :ok
    end
    
  end
end
