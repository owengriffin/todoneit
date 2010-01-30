Feature: Registration
  In order to add tasks
  As a guest
  I want to register as a user

  Scenario: Simple registration
    Given I have no data
    Given I am on the registration page
    And I fill in "user_username" with "testuser"
    And I fill in "user_email_address" with " test@test.com"
    And I fill in "user_password" with "password"
    And I press "Sign up"
    Then I should see the text "Logout"
    Then I should not see the text "Sign up"

  Scenario: Duplicate usernames
    Given I have no data
    Given I have a user called "testuser" with email address "test@test.com"
    Given I am on the registration page
    And I fill in "user_username" with "testuser"
    And I fill in "user_email_address" with "test@test.com"
    And I fill in "user_password" with "password"
    And I press "Sign up"
    Then I should see the text "Username is already taken"

  Scenario: Duplicate email address
    Given I have no data
    Given I have a user called "testuser" with email address "test@test.com"
    Given I am on the registration page
    And I fill in "user_username" with "testuser0"
    And I fill in "user_email_address" with "test@test.com"
    And I fill in "user_password" with "password"
    And I press "Sign up"
    Then I should see the text "Email address is already taken"
