Feature: Tests a page using SitePrism (on top of Capybara framework)
  In order to ...
  As a ...
  I want to ...

  Scenario: Validate the section About Me
    Given I am on the home page, using SitePrism
    When I go to section About
    Then it shows "Oscar Barrios" as profile name
    And it contains "Quality Process and Automation" at the description
    And it has a photo

  Scenario: Validate the current job
    Given I am on the home page, using SitePrism
    When I go to section Career
    Then the current job title is "Senior Test Automation Specialist"
    And the current job company name is "SUSE"

  Scenario: Check the blog entries
    Given I am on the home page, using SitePrism
    When I go to the blog page

