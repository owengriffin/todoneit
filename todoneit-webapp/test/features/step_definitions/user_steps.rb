require 'test/unit'
require 'culerity'

Given /I have a user called "(.+)" with email address "(.+)"$/ do |username, email_address| 
  Given "I am on the registration page"
  And "I fill in \"user_username\" with \"#{username}\""
  And "I fill in \"user_email_address\" with \"#{email_address}\""
  And "I fill in \"user_password\" with \"password\""
  And "I press \"Sign up\""
  Then "I should see the text \"Logout\""
  And "I click \"Logout\""
end

Given /I am logged in as "(.+)"$/ do |username|
  Given "I am on the login page"
  And "I fill in \"username\" with \"#{username}\""
  And "I fill in \"password\" with \"password\""
  And "I press \"Login\""
  Then "I should see the text \"Logout\""
end
