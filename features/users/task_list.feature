@selenium
@javascript

Feature: Task list
  In order to manage task lists
  As a user
  I want create, delete and update task lists

  Background:
    Given I exist as a user
    And I should see user menu

  Scenario: User can create task list
    When I create task list with valid data
    Then I see successful create task list message
    When I create task list with invalid data
    Then I see an invalid create task list messages
    When I create project with valid data
    Then I see successful create project message
    When I create task list with valid data in project
    Then I see successful create task list message in project

  Scenario: User can edit task list
    When I create task list with valid data
    Then I see successful create task list message
    When I update task list with valid data
    Then I see successful update task list message
    When I update task list with invalid data
    Then I see an invalid update task list messages

  Scenario: User can destroy task list
    When I create task list with valid data
    Then I see successful create task list message
    When I destroy task list
    Then I should see user menu
    And I see successful destroy task list message