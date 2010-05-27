
module Xvfb
  module Rake
    class XvfbStartTask
      attr_accessor :font_path, :resolution, :display, :redirect, :background, :xvfb_cmd, :name

      def initialize(name = :'xvfb:start')
        @name = 'xvfb'
        @font_path = determine_font_path
        @resolution = '1024x768x24'
        @display = ':1'
        @redirect = " &> /dev/null"
        @background = true
        yield self if block_given?
        define
      end

      def xvfb_cmd
        `which Xvfb`
      end

      # I'm not sure if there's a more elegant way to shutdown xvfb
      # FXIME: PORT INCOMPLETE
      def self.terminate
        xvfb_pid = `pidof #{prepare_xvfb_cmd}`
        Process.kill :SIGTERM, xvfb_pid.to_i unless xvfb_pid.empty?
        puts cmd if verbose?
      end

      def self.start
        # Nautilius
      end

      def self.prepare_xvfb_cmd
        cmd = "#{xvfb_cmd} #{@display} -fp #{@font_path} -screen #{@display} #{@resolution}"
        cmd += @redirect if @redirect
        cmd += " &" if @background 
      end

      # NOTE: Tested with Debian Lenny & various Ubuntu distros only
      #
      def determine_font_path
        if RUBY_PLATFORM =~ /linux/
          case `cat /etc/issue`
          when /Debian|Ubuntu/
            return '/usr/share/fonts/X11/misc'
          else
            return ENV['XVFB_FONT_PATH'] if ENV['XVFB_FONT_PATH']
          end
        end
        raise "#{RUBY_PLATOFRM} not supported by default, Export $XVFB_FONT_PATH with a path to your X11 fonts/misc directory"
      end

      # NOTE: Move
      def screenshot
        cmd = "import -window root -display #{@display} #{ENV['output'] || 'capture.png'}"
      end

      def screenshot_prereqs
      end

      def xvfb_prereq
        if xvfb_supported_env?
          raise xvfb_install_message unless `dpkg -l | grep xvfb`.chomp.empty?
        else
          raise xvfb_sorry_message
        end
      end

      def xvfb_sorry_message
      end

      def xvfb_install_message
        msg = <<-MSG
Try installing xvfb via `sudo apt-get install xvfb`
MSG
      end

      def define
        desc 'Start Xvfb for Selenium RC'
        task :"#{@name}:start" do
          prereq_check
          # Actually start xvfb
          puts "Xvfb started on display: #{@display} with resolution: #{@resolution}" # if ENV['verbose']
          self.start
        end
        task :"#{@name}:stop" do
          # stop
          # NOTE: Use a shell script here instead of a SIGTERM?
          self.terminate
        end
      end

    end
  end # Rake
end # Xvfb


