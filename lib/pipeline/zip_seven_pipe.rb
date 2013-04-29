module Pipeline
  class ZipSevenPipe < Pipe
    def initialize
      super('7Z', 1, 0)
    end
    
    def work
      work_dir = '/Users/nikitazu/clerk'
      archive_dir = '/Users/nikitazu/clerk/7z'
      
      bin = '/opt/local/bin/7za'
      options = "a -t7z -v4m -y -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -mhe=on"
      
      file = @source.items[0]
      archive = "#{file}.7z"
      
      a_file = "#{work_dir}/#{file}"
      a_archive = "#{archive_dir}/#{archive}"
      
      make_empty_dir archive_dir
      output = %x[#{bin} #{options} #{a_archive} #{a_file} 2>&1]
      
      if not $?.success?
        log "error: #{output}"
        return :fail
      end
      
      parts = Dir["#{archive_dir}/*"]
      log "volumes created #{parts}"
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
end
