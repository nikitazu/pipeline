require 'pipeline/pipe'

module Pipeline
  class ZipSevenPipe < Pipe
    def initialize
      super('7Z', 1, 0)
      @config[:part_size_mb] = '4'
      @config[:zip_binary] = '/opt/local/bin/7za'
    end
    
    def check_before_work
      @path = @source.items[0]
      filename = File.basename(@path)
      archive_to_name = "#{filename}.7z"
      @archive_to_dir = "#{@path}.7z.d"
      @archive_to_path = File.join(@archive_to_dir, archive_to_name)
      
      make_empty_dir @archive_to_dir
      
      @zip_binary = @config[:zip_binary]
      if not File.exists?(@zip_binary)
        log "error: zip binary not found #{@zip_binary}"
        return :fail
      end
      
      @part_size_mb = @config[:part_size_mb].to_i
      if @part_size_mb <= 0
        log "error: wrong part size #{@part_size_mb}"
        return :fail
      end
      
      return :ok
    end
    
    def work
      bin = @config[:zip_binary]
      options = "a -t7z -v#{@part_size_mb}m -y -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -mhe=on"
      output = %x[#{bin} #{options} '#{@archive_to_path}' '#{@path}' 2>&1]
      
      log "options: #{options}"
      
      if not $?.success?
        log "error: #{output}"
        return :fail
      end
      
      @parts = ZipSevenSort.sort(Dir["#{@archive_to_dir}/*"])
      log "volumes created #{@parts}"
      
      return :ok
    end
    
    def check_after_work
      @parts.each do |part|
        if not File.exists?(part)
          log "error: archive part not found #{part}"
          return :fail
        end
        
        @target.add part
      end
      
      return :ok
    end
    
    def make_empty_dir(path)
      destroy_fs_entry path
      Dir.mkdir path
    end

    def destroy_fs_entry(path)
      if File.exist?(path)
        if File.directory?(path)
          Dir["#{path}/*"].each { |f| File.delete f }
          Dir.rmdir path
        else
          File.delete path
        end
      end
    end
    
  end
  
  module ZipSevenSort
    def sort(names)
      names.sort do |one, two|
        one3 = one[-3, one.length].to_i
        two3 = two[-3, two.length].to_i
        one3 <=> two3
      end
    end
    
    module_function :sort
  end
end
