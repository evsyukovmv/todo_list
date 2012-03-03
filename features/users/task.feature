@selenium
@javascript

Feature: Task
  In order to manage tasks
  As a user
  I want create, delete and update tasks

  Background:
    Given I exist as a user
    And I should see user menu
    When I create task list with valid data
    Then I see successful create task list message
    When I create task with valid data in task list
    Then I see successful create task message in task list

  Scenario: User can create task
    When I create task with invalid data in task list
    Then I see an invalid create task messages in task list

  Scenario: User can edit task
    When I update task with valid data
    Then I see successful update task message
    When I update task with invalid data
    Then I see an invalid update task messages

  Scenario: User can destroy task
    When I destroy task
    Then I should see user menu
    And I see successful destroy task message

  Scenario: User can change state of task
    When I change state of task
    Then I see task is in process
    When I change state of task
    Then I see task is done
    When I change state of task
    Then I see task id not done

  Scenario: User can assign task to other users in project
    When I create project with valid data
    Then I see successful create project message
    When I create and invite other user to project
    Then I see invited user in project
    And Other user can see my project
    When I create task list with valid data in project
    Then I see successful create task list message in project
    When I create task with valid data assign to other user in task list in project
    Then I see successful created task assigned to other in task list in project
    When I update task with valid data assign to other user in task list in project
    Then I see successful updated task assigned to other in task list in project
