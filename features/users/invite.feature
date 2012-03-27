@selenium
@javascript

Feature: Invite
  In order user can invite users to project
  As a user
  I want invite other users to project

  Background:
    Given I am logged in
    And I have project
    And Exist other user

  Scenario: User can invite other users to project
    When I invite other user to project
    Then I see invited user in project
    And Other user can see my project

  Scenario: User can remove invited users from project
    When I have invited other user to project
    And I remove user from project
    Then I do not see removed invited user in project