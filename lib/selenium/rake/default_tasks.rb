require 'selenium/rake/tasks'

Selenium::Rake::RemoteControlStartTask.new do |rc|
  rc.timeout_in_seconds = 3 * 60
  rc.background = true
  rc.nohup = false
  rc.wait_until_up_and_running = true
  rc.additional_args << "-singleWindow"
end

Selenium::Rake::RemoteControlStopTask.new

desc "Restart Selenium Remote Control"
task :'selenium:rc:restart' do
  Rake::Task[:'selenium:rc:stop'].execute [] rescue nil
  Rake::Task[:'selenium:rc:start'].execute []
end

# Xvfb for headless servers
Selenium::Rake::XvfbStartTask.new do |x|
  x.resolution = '1024x768x24'
  x.display = ENV['SELENIUM_XVFB_DISPLAY]'] || ':1'
  x.redirect = ' &> /dev/null'
  x.background = true
end



