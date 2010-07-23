module Nautilus
  
  class Shell
    attr_accessor :pidfile
    
    def run(command, options = {})
      sh build_command(command, options), options
    end

    def build_command(command, options = {})
      actual_command = command.kind_of?(Array) ? command.join(" ") : command
      if options[:background]
        actual_command = if windows?
          "start /wait /b #{actual_command}"
        elsif options[:nohup]
          "nohup #{actual_command} &"
        else
          "#{actual_command} &"
        end
        if options[:pidfile]
          raise "Unsupported environment, #{RUBY_PLATFORM}" if windows?
          @pidfile ||= options[:pidfile].is_a?(String) ? options[:pidfile] : gen_pidfile
          actual_command += " echo $! > #{@pidfile}"
        end
      end 
      actual_command
    end

    def kill_from_pidfile(pidfile = @pidfile, sig = :TERM)
      if File.exists?(pidfile)
        Process.kill(sig, File.read(pidfile).chomp.to_i) 
        FileUtils.rm_rf pidfile
      end
    end

    def kill_all_from_pidfiles(glob = '/tmp/nautilus.*', sig = :TERM)
      Dir[glob].each { |f| kill_from_pidfile(f, sig) }
    end

    def gen_pidfile
      @pidfile = '/tmp/nautilus.' + DateTime.now.strfmt("%Y%m%d%H%M%s")
    end
            
    def windows?
      RUBY_PLATFORM =~ /mswin/
    end
   
    def sh(command, options = {})
      successful = system(command)
      puts "Running cmd: #{command}"
      raise "Error while running >>#{command}<<" unless successful
    end
    
  end

end
