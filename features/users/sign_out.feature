@selenium
@javascript

Feature: Sign out
  In order to get access to the site
  As a user
  I want to be able to sign in

  Scenario: User signs out with valid data
    Given I exist as a user
    And I am not logged in
    When I sign in with valid user data
    Then I should see user menu
    Given I am not logged in
    Then I should be sign out
    When I return to the site
    Then I should be sign out
