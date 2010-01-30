Feature: Reports
  In order for ToDoneIt to be the best todo list
  As a user
  I should be able to send a report to my boss with the tasks I completed in a time frame
  To make it more than a todo list

  Scenario: A user wishes to report completed tasks
    Given I have no data
    Given I have a user called "testuser" with email address "test@test.com"
    Given I am logged in as "testuser"
    Given I have a completed task called "Yesterday's task" due yesterday
    Given I have a completed task called "Today's task" due today
    Given I have a task called "Tomorrow's task" due tomorrow
    Given I have a task called "An old task" due the day before yesterday
    Given I have a task called "A future task" due the day after tomorrow
    Given I am on the reports page
    Then I press "Create report"
    Then I should see the text "Report subject"
    And I fill in "report_name" with "Weekly progress"
    Then I should see the text "Enter the email address of the person you wish to report to"
    And I fill in "report_email_address" with "myboss@test.com"
    And I press "Add contact"
    Then I should see the text "Select the tasks you wish to report"
    And I select "All completed"
    Then I should see the text "Yesterday's task"
    And I select "Today's tasks"
    Then I should see the text "Today's task"
    And I press "Preview report"
    Then I should see the text "This is a preview of the text which will be emailed to myboss@test.com"
    And I select "cc_me"
    And I press "Email this now"
    Then I should see the text "Would you like to save this report and send it periodically?"
    And I choose "Yes"
    Then I should see the text "How often would you like to send this?"
    And I fill in "report_period" with "every week on friday afternoon"
    Then I should see the text "Date validated"
    And I press "Save"
    

  Scenario: I only wish to report tasks with a particular tag
    
    
    
