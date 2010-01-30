Feature: Completing tasks
  In order for users to feel as if they are making progress in life
  As a user
  I want to be able to complete my tasks
  To increase my karma

  Scenario: Completing a task
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
    Then I click "Complete"
    And the task "Task #1" has the class "complete"

  Scenario: Completing multiple tasks
    Given I have no data
    Given I have a user called "testuser" with email address "test@test.com"
    Given I am logged in as "testuser"
    Given I have a task called "Task #1" due today
    Given I have a task called "Task #2" due today
    Given I have a task called "Task #3" due today
    Given I am on the home page
    When I wait for the AJAX call to finish
    Then I select the task "Task #1"
    And the task "Task #1" has the class "selected"
    And the menu is displayed
    And the number of tasks selected is "1"
    Then I select the task "Task #3"
    And the task "Task #3" has the class "selected"
    And the menu is displayed
    And the number of tasks selected is "2"
    Then I click "Complete"
    And the task "Task #1" has the class "complete"
    And the task "Task #3" has the class "complete"
    And the task "Task #2" has the class "incomplete"
  
