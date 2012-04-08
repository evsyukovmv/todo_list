@selenium
@javascript

Feature: Task
  In order to assign tasks to other user
  As a user
  I want assign task to other user in project

  Background:
    Given Exist other user
    And I am logged in
    And I have task list in project with invited user

  Scenario: User can assign task to other users in project
    When I create task with valid data assign to other user
    Then I see successful created task assigned to other user

  Scenario: User can update assign task
    Given I create task with valid data assign to other user
    When I update task with valid data assign to self
    Then I see successful updated task assigned to self
