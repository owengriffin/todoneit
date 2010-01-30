Feature: Timeline
  In order for users to be able to see what tasks there are in the near future and past
  As a user
  I want to see the the tasks from yesterday, any time before that, tomorrow and any time before that 
  To make the website more useful

  Scenario: Tasks incomplete which were due yesterday
    Given I have no data
    Given I have a user called "testuser" with email address "test@test.com"
    Given I am logged in as "testuser"
    Given I have a task called "Yesterday's task" due yesterday
    Given I have a task called "Today's task" due today
    Given I have a task called "Tomorrow's task" due tomorrow
    Given I have a task called "An old task" due the day before yesterday
    Given I have a task called "A future task" due the day after tomorrow
    Given I am on the timeline page
    Then I should see the text "Yesterday's task" in the "yesterday" area
    Then I should see the text "Today's task" in the "today" area
    Then I should see the text "Tomorrow's task" in the "tomorrow" area
    Then I should see the text "An old task" in the "previously" area
    Then I should see the text "A future task" in the "future" area
    
