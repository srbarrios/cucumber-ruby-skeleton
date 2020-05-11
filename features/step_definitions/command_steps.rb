Given(/^I have ssh access to the server$/) do
  raise "#{ENV['SERVER']} has not port #{ENV['SSH_PORT']} open" unless port_is_open(ENV['SERVER'], ENV['SSH_PORT'])
end

Given(/^I have access to "([^"]*)" local filename$/) do |filename|
  filepath = "#{File.dirname(__FILE__)}/../upload_files/#{filename}"
  raise "Local filename #{filename} not found" unless File.file?(filepath)
end

When(/^I run a command on the server$/) do
  result = $server.ssh('echo test')
  raise "Command failed: #{result[:stderr]}" unless result[:stderr].empty?
end

When(/^I copy "([^"]*)" file into the server temporal path$/) do |filename|
  filepath = File.expand_path("#{File.dirname(__FILE__)}/../upload_files/#{filename}")
  $server.scp(filepath,  "/tmp/#{filename}")
end

When(/^I remove "([^"]*)" file from the server temporal path$/) do |filename|
  filepath = "#{File.dirname(__FILE__)}/../upload_files/#{filename}"
  result = $server.ssh("rm /tmp/#{filepath}")
  raise "#{filename} can't be removed" unless result[:stderr].empty?
end

Then(/^I should((?: not)?) see "([^"]*)" file in my server$/) do |should_not, filename|
  result = $server.ssh("ls #{filename}")
  if should_not.nil?
  	raise "File #{filename} not found. Error: #{result[:stderr]}" unless result[:stderr].empty?
  else
  	raise "File #{filename} found. Error: #{result[:stderr]}" if result[:stderr].empty?
  end
end
