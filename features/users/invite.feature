@selenium
@javascript

Feature: Invite
  In order user can invite users to project
  As a user
  I want invite other users to project

  Background:
    Given Exist other user
    And I am logged in
    And I have project

  Scenario: User can invite other users to project
    When I invite other user to project
    Then I see invited user in project

  Scenario: Invited user can see my project
    Given Invited user logged in
    When Invited user open projects
    Then Invited user can see my project

  Scenario: User can remove invited users from project
    Given I invite other user to project
    When I remove user from project
    Then I can't see other user in project