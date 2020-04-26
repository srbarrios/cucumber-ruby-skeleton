Feature: Title of my feature A
  In order to ...
  As a ...
  I want to ...

  Scenario: Title of the first scenario of feature A
    When I go to the home page
    Then I should see "Oubiti" button

  @tag_enabled
  Scenario: Title of the second scenario which only runs if the tag is enabled
    Given I am on the home page
    When I click on "Oubiti" button
    Then I should see a "About Me" text
