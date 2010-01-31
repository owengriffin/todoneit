Feature: Prioritise tasks
  In order for users to know what to focus on
  As a user
  I want to be able to make some tasks more important than others
  To increase my karma

  Scenario: Raising the priority of a task
    Given I have no data
    Given I have a user called "testuser" with email address "test@test.com"
    Given I am logged in as "testuser"
    Given I have a task called "Task #1" due today
    Given I am on the home page
    When I wait for the AJAX call to finish
    Then I select the task "Task #1"
    And the task "Task #1" has the class "selected"
    And the menu is displayed
    And the number of tasks selected is "1"
    Then I click "Raise priority"
    When I wait for the AJAX call to finish
    And the task "Task #1" has the class "priority3"

  Scenario: Lowering the priority of a task
    Given I have no data
    Given I have a user called "testuser" with email address "test@test.com"
    Given I am logged in as "testuser"
    Given I have a task called "Task #1" due today
    Given I am on the home page
    When I wait for the AJAX call to finish
    Then I select the task "Task #1"
    And the task "Task #1" has the class "selected"
    And the menu is displayed
    And the number of tasks selected is "1"
    Then I click "Raise priority"
    When I wait for the AJAX call to finish
    And the task "Task #1" has the class "priority3"
    Then I select the task "Task #1"
    And the task "Task #1" has the class "selected"
    And the menu is displayed
    And the number of tasks selected is "1"
    Then I click "Raise priority"
    When I wait for the AJAX call to finish
    And the task "Task #1" has the class "priority2"
    Then I select the task "Task #1"
    And the task "Task #1" has the class "selected"
    And the menu is displayed
    And the number of tasks selected is "1"
    Then I click "Raise priority"
    When I wait for the AJAX call to finish
    And the task "Task #1" has the class "priority1"
    Then I select the task "Task #1"
    And the task "Task #1" has the class "selected"
    And the menu is displayed
    And the number of tasks selected is "1"
    Then I click "Lower priority"
    When I wait for the AJAX call to finish
    And the task "Task #1" has the class "priority2"
  
