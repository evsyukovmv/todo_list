@selenium
@javascript

Feature: Project
  In order to manage projects
  As a user
  I want create, delete and update projects

  Background:
    Given I exist as a user
    And I should see user menu
    When I create project with valid data
    Then I see successful create project message

  Scenario: User can create project
    When I create project with invalid data
    Then I see an invalid create project messages

  Scenario: User can edit project
    When I update project with valid data
    Then I see successful update project message
    When I update project with invalid data
    Then I see an invalid update project messages

  Scenario: User can destroy project
    When I destroy project
    Then I should see user menu
    And I see successful destroy project message

  Scenario: User can invite other users to project
    When I create and invite other user to project
    Then I see invited user in project
    And Other user can see my project

  Scenario: User can remove invited users from project
    When I create and invite other user to project
    Then I see invited user in project
    When I remove user from project
    Then I do not see removed invited user in project