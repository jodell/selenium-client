require 'xvfb/rake/tasks'
require 'nautlius/shell'

# Xvfb for headless servers
Selenium::Rake::XvfbStartTask.new do |x|
  x.name = :'xvfb:start'
  x.resolution = '1024x768x24'
  x.display = ENV['SELENIUM_XVFB_DISPLAY]'] || ':1'
  x.pidfile = '/tmp/xvfb-1024x768x24.pid'
  x.redirect = ' &> /dev/null'
  x.background = true
  x.nohup = true
end

Selenium::Rake::XvfbStopTask.new do |x|
  x.name = :'xvfb:stop'
  x.resolution = '1024x768x24'
  x.display = ENV['SELENIUM_XVFB_DISPLAY]'] || ':1'
  x.pidfile = '/tmp/xvfb-1024x768x24.pid'
  x.redirect = ' &> /dev/null'
  x.background = true
  x.nohup = true
end

Selenium::Rake::XvfbScreenShotTask.new do |x|
  x.name = :'xvfb:screenshot'
  x.display = ENV['SELENIUM_XVFB_DISPLAY]'] || ':1'
  x.basename = ENV['XVFB_SCREENSHOT_BASE'] || 'screen_cap'
  x.timestamps = true
end

# Second set to demonstrate differentiating Xvfb sessions
Selenium::Rake::XvfbStartTask.new do |x|
  x.name = :'xvfb:big:start'
  x.resolution = '1600x1200x24'
  x.display = ENV['SELENIUM_XVFB_LARGE_DISPLAY]'] || ':2'
  x.pidfile = '/tmp/xvfb-1600x1200x24.pid'
  x.redirect = ' &> /dev/null'
  x.background = true
  x.nohup = true
end

Selenium::Rake::XvfbStopTask.new do |x|
  x.name = :'xvfb:big:stop'
  x.resolution = '1600x1200x24'
  x.display = ENV['SELENIUM_XVFB_LARGE_DISPLAY]'] || ':2'
  x.pidfile = '/tmp/xvfb-1600x1200x24.pid'
  x.redirect = ' &> /dev/null'
  x.background = true
  x.nohup = true
end

Selenium::Rake::XvfbScreenShotTask.new do |x|
  x.name = :'xvfb:big:screenshot'
  x.display = ENV['SELENIUM_XVFB_LARGE_DISPLAY]'] || ':2'
  x.basename = ENV['XVFB_SCREENSHOT_BASE]'] || 'screen_cap'
  x.timestamps = true
end

# Small resolution set
Selenium::Rake::XvfbStartTask.new do |x|
  x.name = :'xvfb:small:start'
  x.resolution = '800x600x24'
  x.display = ENV['SELENIUM_XVFB_SMALL_DISPLAY]'] || ':3'
  x.pidfile = '/tmp/xvfb-800x600x24.pid'
  x.redirect = ' &> /dev/null'
  x.background = true
  x.nohup = true
end

Selenium::Rake::XvfbStopTask.new do |x|
  x.name = :'xvfb:small:stop'
  x.resolution = '800x600x24'
  x.display = ENV['SELENIUM_XVFB_SMALL_DISPLAY]'] || ':3'
  x.pidfile = '/tmp/xvfb-800x600x24.pid'
  x.redirect = ' &> /dev/null'
  x.background = true
  x.nohup = true
end

Selenium::Rake::XvfbScreenShotTask.new do |x|
  x.name = :'xvfb:big:screenshot'
  x.display = ENV['SELENIUM_XVFB_SMALL_DISPLAY]'] || ':3'
  x.basename = ENV['XVFB_SCREENSHOT_BASE]'] || 'screen_cap'
  x.timestamps = true
end

# helper
desc 'Kill all xvfb processes left in /tmp/xvfb-*.pid'
task :'xvfb:killall' do
  Nautilus::Shell.new.kill_all_from_pidfiles('/tmp/xvfb-*.pid')
end

desc 'Display running Xvfb processes'
task :'xvfb:list' do
  Nautilus::Shell.new.run 'ps aux | grep -i [v]fb | grep -v list'
end

