require 'English'
require 'rubygems'
require 'tmpdir'
require 'base64'
require 'capybara'
require 'capybara/cucumber'
require 'selenium/webdriver'
require 'site_prism'
require 'site_prism/all_there'
require 'securerandom'
require_relative 'remote_node'

## Environment
$tag_enabled = true
$stdout.sync = true
STARTTIME = Time.new.to_i # In use to build the report
$hostname = ENV['SERVER'] || 'oubiti.com'
$ssh_port = ENV['SSH_PORT'] || 22
$debug_mode = true if ENV['DEBUG']

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

Capybara.register_driver(:site_prism) do |app|
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

Capybara.configure do |config|
  config.default_driver = $debug_mode ? :selenium_chrome_headless : :site_prism
  config.default_max_wait_time = 10
  config.javascript_driver = :site_prism
  config.app_host = "https://#{$hostname}"
  config.server_port = 8888 + ENV['TEST_ENV_NUMBER'].to_i # Useful for concurrent threads
end

log "Capybara APP Host: #{Capybara.app_host}:#{Capybara.server_port}"

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

def take_screenshot(scenario_name)
  begin
    img_path = "screenshots/#{scenario_name.tr(' ./', '_')}.png"
    if page.driver.browser.respond_to?(:save_screenshot)
      Dir.mkdir("screenshots") unless File.directory?("screenshots")
      page.driver.browser.save_screenshot(img_path)
    else
      save_screenshot(img_path)
    end
    # embed the image name in the cucumber HTML report
    attach current_url, 'text/plain'
    attach img_path, 'image/png'
  rescue StandardError => e
    log "Error taking a screenshot: #{e.message}"
  end
end

# Embed a screenshot after each failed scenario
After do |scenario|
  if scenario.failed?
    take_screenshot(scenario.name)
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
