@selenium
@javascript

Feature: Access
  In order content must be protected
  As a user
  I do not have access to content without rights

  Scenario: Not logged in user tries to open a protected pages
    Given I am not logged in
    When I open protected paths
    Then I turn on access denied page

  Scenario: User cannot view content other users
    Given There are several users with contents
    When I try open another user content
    Then I turn on access denied page