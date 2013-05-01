require 'zip/zip'
require 'pipeline/pipe'

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
      volumes = split(archive, 4 * 1024 * 1024)
      log "resulting volumes are #{volumes}"
      
      return :ok
    end
    
    SPLIT_SIGNATURE = 0x08074b50
    MAX_SEGMENT_SIZE = 3221225472
    MIN_SEGMENT_SIZE = 65536
    DATA_BUFFER_SIZE = 8192
        
    # Splits an archive into parts with segment size
    def split(zip_file_name, segment_size=MAX_SEGMENT_SIZE, delete_zip_file=true, partial_zip_file_name=nil)
      raise Zip::ZipError, "File #{zip_file_name} not found" unless ::File.exists?(zip_file_name)
      raise Errno::ENOENT, zip_file_name unless ::File.readable?(zip_file_name)


      zip_file_size = ::File.size(zip_file_name)
      segment_size = MIN_SEGMENT_SIZE if MIN_SEGMENT_SIZE > segment_size
      segment_size = MAX_SEGMENT_SIZE if MAX_SEGMENT_SIZE < segment_size
      return if zip_file_size <= segment_size

      segment_count = (zip_file_size / segment_size).to_i +
        (zip_file_size % segment_size == 0 ? 0 : 1)

      # Checking for correct zip structure
      Zip::ZipFile.open(zip_file_name) {}


      partial_zip_file_name = zip_file_name.sub(/#{File.basename(zip_file_name)}$/,
        partial_zip_file_name + File.extname(zip_file_name)) unless partial_zip_file_name.nil?

      partial_zip_file_name ||= zip_file_name

      szip_file_index = 0
      ::File.open(zip_file_name, 'rb') do |zip_file|
        until zip_file.eof?
          szip_file_index += 1
          ssegment_size = (zip_file_size - zip_file.pos) >= segment_size ? segment_size : zip_file_size - zip_file.pos
          szip_file_name = "#{partial_zip_file_name}.#{'%03d'%(szip_file_index)}"
          ::File.open(szip_file_name, 'wb') do |szip_file|
            if szip_file_index == 1
              signature_packed = [SPLIT_SIGNATURE].pack('V')
              szip_file << signature_packed
              ssegment_size = segment_size - signature_packed.size
            end

            chunk_bytes = 0
            until ssegment_size == chunk_bytes || zip_file.eof?
              segment_bytes_left = ssegment_size - chunk_bytes
              buffer_size = segment_bytes_left < DATA_BUFFER_SIZE ? segment_bytes_left : DATA_BUFFER_SIZE

              chunk = zip_file.read(buffer_size)
              chunk_bytes += buffer_size

              szip_file << chunk
              # Info for track splitting
              yield segment_count, szip_file_index, chunk_bytes, ssegment_size if block_given?
            end
          end
        end
      end

      ::File.delete(zip_file_name) if delete_zip_file

      szip_file_index
    end

  end
end
