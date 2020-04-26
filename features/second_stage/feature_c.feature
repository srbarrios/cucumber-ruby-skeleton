Feature: Title of my feature C
  In order to ...
  As a ...
  I want to ...

  Scenario: Title of the first scenario of feature C
    Given I have ssh access to the server
    And I have access to "test.json" local filename
    When I copy "test.json" file into the server temporal path
    Then I should see "test.json" file in my server

  Scenario: Clean up scenario of feature C
    Given I have ssh access to the server
    When I remove "test.json" file from the server temporal path
    Then I should not see "test.json" file in my server
