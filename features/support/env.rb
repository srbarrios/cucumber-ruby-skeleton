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
$hostname = ENV['SERVER'] || 'oubiti.com'
$ssh_port = ENV['SSH_PORT'] || 22
$debug_mode = !ENV['DEBUG'].nil?

## Remote nodes
$server = RemoteNode.new($hostname, port = $ssh_port, user = 'data', password = 'test')

## Capybara
CHROME_OPTIONS = %W(
  --no-sandbox
  --disable-dev-shm-usage
  --disable-gpu
  --disable-translate
  --hide-scrollbars
  --ignore-certificate-errors
  --ignore-ssl-errors
  --ignore-certificate-errors-spki-list
  --user-data-dir=/tmp
  --window-size=2048,2048
)

CHROME_OPTIONS << '--headless' unless $debug_mode
CHROME_OPTIONS.freeze

Capybara.register_driver(:headless_chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: CHROME_OPTIONS },
    unexpectedAlertBehaviour: 'accept',
    unhandledPromptBehavior: 'accept'
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
Capybara.app_host = "https://#{$hostname}"
Capybara.server_port = 8888 + ENV['TEST_ENV_NUMBER'].to_i # Useful for concurrent threads
Kernel.puts "Capybara APP Host: #{Capybara.app_host}:#{Capybara.server_port}"

## Cucumber 

# Code running before each scenario
Before('@tag_enabled') do
  skip_this_scenario unless $tag_enabled
end

Before do |scenario|
  current_time = Time.new
  @scenario_start_time = current_time.to_i
  log "This scenario ran at: #{current_time} - #{@scenario_start_time - STARTTIME} seconds since start"
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
      log "Error taking a screenshot: #{e.message}"
    end
  end
end

After do |scenario|
  current_epoch = Time.new.to_i
  log "This scenario took: #{current_epoch - @scenario_start_time} seconds"
end

# Code running after each step
AfterStep do
  nil
end
