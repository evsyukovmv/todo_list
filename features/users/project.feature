@selenium
@javascript

Feature: Project
  In order to manage projects
  As a user
  I want create, delete and update projects

  Background:
    Given I am logged in

  Scenario: User can crate project with valid data
    When I create project with valid data
    Then I see successful create project message

  Scenario: User cannot create project with invalid data
    When I create project with invalid data
    Then I see an invalid create project messages

  Scenario: User can edit project with valid data
    Given I have project
    When I update project with valid data
    Then I see successful update project message

  Scenario: User can't update project with invalid data
    Given I have project
    When I update project with invalid data
    Then I see an invalid update project messages

  Scenario: User can destroy project
    Given I have project
    When I destroy project
    Then I see successful destroy project message