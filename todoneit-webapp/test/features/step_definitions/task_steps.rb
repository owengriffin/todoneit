require 'test/unit'
require 'culerity'

Given /^I have a task called "([^\"]*)" due ([^\"]*)/ do |name, due_at| 
  Given "I am on the new task page"
  And "I fill in \"task_description\" with \"#{name}\""
  And "I fill in \"task_due_at\" with \"#{due_at}\""
  And "I press \"Add\""
  Then "I should see the text \"Your task has been added\""
end

And /^I select the task "([^\"]*)"/ do |name|
  $browser.div(:text => name).click
end

And /^the task "([^\"]*)" has the class "([^\"]*)"/ do |name, class_name|
  fail if not $browser.div(:text => name).parent.class_name.include? class_name
end

And /^the menu is displayed/ do 
  fail if not $browser.div(:id => "menu").visible?
end

And /^the number of tasks selected is "([^\"]*)"/ do |number|
  fail if not $browser.div(:class_name => "totalSelected", :index => 1).text == "#{number} selected"
end
