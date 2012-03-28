@selenium
@javascript

Feature: Task
  In order to manage tasks
  As a user
  I want create, delete and update tasks

  Background:
    Given I am logged in
    And I have task list

  Scenario: User can create task
    When I create task with valid data in task list
    Then I see successful create task message in task list

  Scenario: User can't create task
    When I create task with invalid data in task list
    Then I see an invalid create task messages in task list

  Scenario: User can edit task
    Given I have task
    When I update task with valid data
    Then I see successful update task message

  Scenario: User can't edit task list with invalid data
    Given I have task
    When I update task with invalid data
    Then I see an invalid update task messages

  Scenario: User can destroy task
    Given I have task
    When I destroy task
    And I see successful destroy task message

  Scenario: User can change state of task
    Given I have task
    When I change state of task
    Then I see task is in process