
# Supports:
# * Selenium RC Hook for headless testing
# * Screenshots with imagemagick
#
# -jodell 20100528
#
module Xvfb
  class Xvfb
    attr_accessor :font_path, :resolution, :display, :redirect, 
      :background, :nohup, :xvfb_cmd, :pid

    def initialize(options = {})
      @font_path  = options[:font_path]      || determine_font_path
      @resolution = options[:resolution]     || '1024x768x24'
      @display    = options[:display]        || ':1'
      @redirect   = options[:redirect]       || " &> /dev/null"
      @background = options[:background]     || true
      @background = options[:nohup]          || false
      @screenshot = options[:screenshot_dir] || false
      @shell = Nautilius::Shell.new
    end

    def xvfb_cmd
      [
        `which Xvfb`.chomp,
        @display,
        "-fp #{@font_path}",
        "-screen #{@display}",
        @resolution,
      ] * ' ' 
    end

    def start
      @pid = @shell.run(xvfb_cmd, { :background => options[:background], 
                                    :nohup => options[:nohup], :pid => options[:background] }).chomp.to_i
    end

    def stop
      Process.kill :SIGTERM, @pid
    end

    def determine_font_path
      if RUBY_PLATFORM =~ /linux/
        case `cat /etc/issue`
        when /Debian|Ubuntu/
          return '/usr/share/fonts/X11/misc'
        else
          return ENV['XVFB_FONT_PATH'] if ENV['XVFB_FONT_PATH']
        end
      end
      raise "#{RUBY_PLATFORM} not supported by default, Export $XVFB_FONT_PATH with a path to your X11 fonts/misc directory"
    end

    def screenshot(options = {})
      XvfbImport.screenshot(options)
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
  end # Xvfb

  ##
  # Simple use of imagemagick's import utility with Xvfb.
  # Allows basic screenshots while headless.
  #
  # RMagick?
  class XvfbImport
    # -window
    # -display
    class << self
      def screenshot(options = {})
        raise unsupported_msg unless supported?
        cmd = [
          "import",
          "-window #{options[:window] || 'root'}",
          "-display #{@display}",
          "#{options['output'] || ENV['output'] || 'capture.png'}"
        ] * ' '
        @shell.run cmd, {:background => options[:background], :nohup => options[:nohup]}
      end
  
      def supported?
        RUBY_PLATFORM.match /nix/ && imagemagick_installed?
      end
  
      def imagemagick_installed?
  
      end
  
      def unsupported_msg
        "Platform: #{RUBY_PLATFORM} unsupported"
      end
    end
  end

end # Xvfb
