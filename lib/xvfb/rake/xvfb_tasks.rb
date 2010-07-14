
module Xvfb
  module Rake
    class XvfbStartTask
      attr_accessor :font_path, :resolution, :display, :redirect, 
        :background, :xvfb_cmd, :name, :pidfile

      def initialize(name = :'xvfb:start')
        @name = 'xvfb'
        @font_path = '/usr/share/fonts/X11/misc'
        @resolution = '1024x768x24'
        @display = ':1'
        @pidfile = '/tmp/xvfb-1.pid'
        @redirect = " &> /dev/null"
        @background = true
        yield self if block_given?
        define
      end

      def define
        desc 'Start Xvfb for Selenium RC'
        task :"#{@name}:start" do
          @xvfb = Xvfb::Xvfb.new do |xvfb|
            xvfb.resolution = '1024x768x24'
            xvfb.font_path = '/usr/share/fonts/X11/misc'
            xvfb.display = ':1'
            xvfb.pidfile = '/tmp/xvfb-1.pid'
            xvfb.redirect = " &> /dev/null"
            xvfb.background = true
            xvfb.nohup = true
          end

          # Actually start xvfb
          puts "Xvfb started on display: #{@display} with resolution: #{@resolution}" # if ENV['verbose']
          @xvfb.start
        end
      end

    end

    class XvfbStopTask
      attr_accessor :font_path, :resolution, :display, :redirect, :background, :xvfb_cmd, 
        :name, :pidfile

      def initialize(name = :'xvfb:stop')
        @name = :'xvfb:stop'
        @font_path = determine_font_path
        @resolution = '1024x768x24'
        @display = ':1'
        @pidfile = '/tmp/xvfb-1.pid'
        @redirect = " &> /dev/null"
        @background = true
        yield self if block_given?
        define
      end

      def define
        desc 'Stop the Xvfb instance'
        task @name do
          @xvfb = Xvfb::Xvfb.new do |xvfb|
            xvfb.resolution 
            xvfb.resolution = '1024x768x24'
            xvfb.font_path = '/usr/share/fonts/X11/misc'
            xvfb.display = ':1'
            xvfb.pidfile = '/tmp/xvfb-1.pid'
            xvfb.redirect = " &> /dev/null"
            xvfb.background = true
            xvfb.nohup = true
          end
          puts "Xvfb started on display: #{@display} with resolution: #{@resolution}" # if ENV['verbose']
          @xvfb.terminate
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


