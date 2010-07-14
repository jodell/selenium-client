
# Supports:
# * Selenium RC Hook for headless testing
# * Screenshots with imagemagick
#
# -jodell 20100528
#
module Xvfb
  class Xvfb
    attr_accessor :font_path, :resolution, :display, :redirect, 
      :background, :nohup, :xvfb_cmd, :pidfile

    def initialize(options = {})
      @font_path  = options[:font_path]      || determine_font_path
      @resolution = options[:resolution]     || '1024x768x24'
      @display    = options[:display]        || ':1'
      @pidfile    = options[:pidfile]        || '/tmp/xvfb-1.pid'
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
      @shell.run xvfb_cmd, { :background => @background
                             :nohup => @nohup, 
                             :pidfile => @pidfile }
    end

    def stop
      @shell.kill @pidfile
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
  # NOTE: RMagick?
  class XvfbImport
    attr_accessor :shell, :timestamps, :basename, :display
    def initialize(options = {})
      @timestamps = options[:timestamps] || true
      @display    = options[:display] || ':1'
      @window     = options[:window] || 'root'
      @basename   = options[:basename] || "xvfb_screen_shot_#{@window}"
      @extension  = options[:extension] || 'png'
      @shell = Nautilius::Shell.new
    end
    def screenshot(options = {})
      raise RuntimeError, unsupported_msg unless supported?
      cmd = [
        "import",
        "-window #{options[:window] || @window}",
        "-display #{options[:display] || @display}",
        gen_filename,
      ] * ' '
      @shell.run cmd, {:background => options[:background], :nohup => options[:nohup]}
    end

    def gen_filename
      [ 
        @basename,
        (@timestamps ? Time.now.strftime("_%Y%m%d_%H%M%S") : ''),
        '.',
        @extension,
      ].join
    end
  
    def supported?
      imagemagick_installed?
    end
  
    def imagemagick_installed?
      @shell.run 'which import'
    end
  
    def unsupported_msg
      "<#{self.class}> Unsupported: Must have imagemagick installed"
    end
  end

end # Xvfb
