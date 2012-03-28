@selenium
@javascript

Feature: Task list
  In order to manage task lists
  As a user
  I want create, delete and update task lists

  Background:
    Given I am logged in

  Scenario: User can create task list with valid data
    When I create task list with valid data
    Then I see successful create task list message

  Scenario: User can't create task list with invalid data
    When I create task list with invalid data
    Then I see an invalid create task list messages

  Scenario: User can create task list in project
    Given I have project
    When I create task list with valid data in project
    Then I see successful create task list message in project

  Scenario: User can edit task list
    Given I have task list
    When I update task list with valid data
    Then I see successful update task list message

  Scenario: User can't edit task with invalid data
    Given I have task list
    When I update task list with invalid data
    Then I see an invalid update task list messages

  Scenario: User can destroy task list
    Given I have task list
    When I destroy task list
    And I see successful destroy task list message