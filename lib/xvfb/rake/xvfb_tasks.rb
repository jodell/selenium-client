
module Xvfb
  module Rake
    class XvfbStartTask
      attr_accessor :font_path, :resolution, :display, :redirect, 
        :background, :nohup, :xvfb_cmd, :name, :pidfile

      def initialize(name = :'xvfb:start')
        @name = :'xvfb:start'
        @font_path = '/usr/share/fonts/X11/misc'
        @resolution = '1024x768x24'
        @display = ':1'
        @pidfile = '/tmp/xvfb-1.pid'
        @redirect = " &> /dev/null"
        @background = true
        @nohup = true
        yield self if block_given?
        define
      end

      def define
        desc 'Start Xvfb for Selenium RC'
        task @name do
          xvfb = Xvfb::XvfbServer.new do |x|
            x.resolution = @resolution
            x.font_path = @font_path
            x.display = @display
            x.pidfile = @pidfile
            x.redirect = @redirect
            x.background = @background
            x.nohup = @nohup
          end

          # Actually start xvfb
          puts "Xvfb started on display: #{@display} with resolution: #{@resolution} and pidfile: #{@pidfile}" # if ENV['verbose']
          xvfb.start
        end
      end

    end

    class XvfbStopTask
      attr_accessor :font_path, :resolution, :display, :redirect, :background, :nohup, :xvfb_cmd, 
        :name, :pidfile

      def initialize(name = :'xvfb:stop')
        @name = :'xvfb:stop'
        @font_path = '/usr/share/fonts/X11/misc'
        @resolution = '1024x768x24'
        @display = ':1'
        @pidfile = '/tmp/xvfb-1.pid'
        @redirect = " &> /dev/null"
        @background = true
        @nohup = true
        yield self if block_given?
        define
      end

      def define
        desc 'Stop the Xvfb instance'
        task @name do
          xvfb = Xvfb::XvfbServer.new do |x|
            x.resolution = @resolution
            x.font_path = @font_path
            x.display = @display
            x.pidfile = @pidfile
            x.redirect = @redirect
            x.background = @background
            x.nohup = @nohup
          end
          puts "Xvfb stopped on display: #{@display} with resolution: #{@resolution} and pidfile #{@pidfile}" # if ENV['verbose']
          xvfb.stop
        end
      end

    end

    class XvfbScreenShotTask 
      def initialize(name = :'xvfb:screenshot')
      end

      def define
        desc 'Take a screenshot under Xvfb'
        task @name do
        end
      end
    end
  end # Rake
end # Xvfb


