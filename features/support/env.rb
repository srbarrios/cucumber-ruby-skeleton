require 'English'
require 'rubygems'
require 'tmpdir'
require 'base64'
require 'capybara'
require 'capybara/cucumber'
require 'selenium/webdriver'
require 'securerandom'
require_relative 'remote_node'




## Environment
$tag_enabled = true
$stdout.sync = true
STARTTIME = Time.new.to_i # In use to build the report

## Remote nodes
$server = RemoteNode.new(ENV['SERVER'], ssh_port = ENV['SSH_PORT'], user = 'data', password = 'test')

## Capybara
CHROME_OPTIONS = %w(
  --no-sandbox
  --disable-background-networking
  --disable-default-apps
  --disable-dev-shm-usage
  --disable-extensions
  --disable-sync
  --disable-gpu
  --disable-translate
  --headless
  --hide-scrollbars
  --metrics-recording-only
  --mute-audio
  --no-first-run
  --safebrowsing-disable-auto-update
  --ignore-certificate-errors
  --ignore-ssl-errors
  --ignore-certificate-errors-spki-list
  --user-data-dir=/tmp
  --window-size=2048,2048
  --disable-popup-blocking
).freeze

Capybara.register_driver(:headless_chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: CHROME_OPTIONS },
    unexpectedAlertBehaviour: 'accept'
  )

  driver_options = Selenium::WebDriver::Chrome::Options.new
  CHROME_OPTIONS.each { |arg| driver_options.add_argument(arg) }
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: driver_options,
    desired_capabilities: capabilities
  )
end

Capybara.default_max_wait_time = 10
Capybara.default_driver = :headless_chrome
Capybara.javascript_driver = :headless_chrome
Capybara.app_host = "https://#{ENV['SERVER']}"
Capybara.server_port = 8888 + ENV['TEST_ENV_NUMBER'].to_i # Useful for concurrent threads
puts "Capybara APP Host: #{Capybara.app_host}:#{Capybara.server_port}"

## Cucumber 

# Code running before each scenario
Before('@tag_enabled') do
  skip_this_scenario unless $tag_enabled
end

Before do |scenario|
  current_time = Time.new
  @scenario_start_time = current_time.to_i
  puts "This scenario ran at: #{current_time} - #{@scenario_start_time - STARTTIME} seconds since start"
end

# Embed a screenshot after each failed scenario
After do |scenario|
  if scenario.failed?
    begin
      img_path = "screenshots/#{scenario.name.tr(' ./', '_')}.png"
      if page.driver.browser.respond_to?(:save_screenshot)
        Dir.mkdir("screenshots") unless File.directory?("screenshots")
        page.driver.browser.save_screenshot(img_path)
      else
        save_screenshot(img_path)
      end
      # embed the image name in the cucumber HTML report
      embed current_url, 'text/plain'
      embed img_path, 'image/png'
    rescue StandardError => e
      puts "Error taking a screenshot: #{e.message}"
    end
  end
end

After do |scenario|
  current_epoch = Time.new.to_i
  puts "This scenario took: #{current_epoch - @scenario_start_time} seconds"
end

# Code running after each step
AfterStep do
  nil
end
