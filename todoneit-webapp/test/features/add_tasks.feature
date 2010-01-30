Feature: Creating tasks
  In order for users to be able to add tasks
  As a user
  I want to add tasks to my list
  To increase usage

  Scenario: Adding a task
    Given I have no data
    Given I have a user called "testuser" with email address "test@test.com"
    Given I am logged in as "testuser"
    Given I am on the new task page
    And I fill in "task_due_at" with "tomorrow"
    And I fill in "task_description" with "Ensure I can add a task"
    And I press "Add"
    Then I should see the text "Your task has been added"
    Then I should see the text "Ensure I can add a task"

  Scenario: Creating a task from the quickadd bar
    Given I have no data
    Given I have a user called "testuser" with email address "test@test.com"
    Given I am logged in as "testuser"
    Given I am on the home page
    Then the field "task[description]" contains "Describe a task here"
    When I press "task[description]"
    Then the field "task[description]" contains ""
    And I fill in "task[description]" with "Test todoneit tomorrow"
    When I submit the "quickadd" form
    Then I should see the text "Your task has been added"
    Then the field "task[description]" contains "Describe a task here"
