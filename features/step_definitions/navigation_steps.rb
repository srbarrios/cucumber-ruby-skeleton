# Capybara hints: https://devhints.io/capybara

## Browse

Given(/^I am on the home page$/) do
  step %(I go to the home page) unless Capybara.app_host == current_url
end

When(/^I go to the home page$/) do
  visit Capybara.app_host
end

## Clicks

When(/^I click on "([^"]*)" button$/) do |button_text|
  raise "Button #{button_text} not clicked" unless find('span', text: button_text).click
end

## Find elements

Then(/^I should see "([^"]*)" button$/) do |button_text|
  raise "Button #{button_text} not found" unless find('span', text: button_text, wait: 3)
end

Then(/^I should see a "([^"]*)" text$/) do |text|
  raise "Text #{text} not found" unless has_text?(text, wait: 2)
end

## Forms

When(/^I enter "([^"]*)" as "([^"]*)"$/) do |text, textfield|
  fill_in textfield, with: text
end

## Screenshot

When(/^I take a screenshot with filename "([^"]*)"$/) do |filename|
  take_screenshot(filename)
end