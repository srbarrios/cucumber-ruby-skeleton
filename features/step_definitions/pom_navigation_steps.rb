Given(/^I am on the home page, using SitePrism$/) do
  step %(I go to the home page, using SitePrism) unless Capybara.app_host == current_url
end

When(/^I go to the home page, using SitePrism$/) do
  @home = HomePage.new
  @home.load
end

When(/^I go to section About$/) do
  @home.go_to_about
end

Then(/^it shows "([^"]*)" as profile name$/) do |name|
  unless @home.about.name.text == name
    raise "'#{@home.about.name.text}' is different than '#{name}'"
  end
end

And(/^it contains "([^"]*)" at the description$/) do |description|
  unless @home.about.description.text.include? description
    raise "'#{@home.about.description.text}' is different than '#{description}'"
  end
end

And(/^it has a photo$/) do
  raise 'Photo not found' if @home.about.photo.nil?
end

When(/^I go to section Career$/) do
  @home.go_to_career
end

Then(/^the current job title is "([^"]*)"$/) do |job_title|
  unless @home.career.job_titles.first.text == job_title
    raise "'#{@home.career.job_titles.first.text}' is different than '#{job_title}'"
  end
end

And(/^the current job company name is "([^"]*)"$/) do |company_name|
  unless @home.career.job_companies.first.text == company_name
    raise "'#{@home.career.job_companies.first.text}' is different than '#{company_name}'"
  end
end

When(/^I go to the blog page$/) do
  @home.go_to_blog
end

