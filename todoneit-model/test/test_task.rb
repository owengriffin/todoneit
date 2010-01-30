require 'helper'

module ToDoneIt
  class TestTask < Test::Unit::TestCase
    context "model" do 
    setup do
      DataMapper.setup(:default, 'sqlite3::memory:')
      DataMapper.auto_migrate!
    end
    context "validations" do

      setup do
        @user = User.new({:username => "username", :password => "password"})
        @user.save
      end

      should "raise an error a description is not present" do
        task = Task.new({:public => true, :user => @user})
        task.save
        assert_equal 1, task.errors.size
        assert_not_nil task.errors[:description]
      end
      should "raise an error when description is too long" do
        description = ""
        60.times { description = description + "X" }
        task = Task.new({:description => description, :public => true, :user => @user})
        task.save
        assert_equal 1, task.errors.size
        assert_not_nil task.errors[:description]
      end
    end
    context "static methods" do
      should "list all before yesterday" do
        user0 = User.new({:username => "username", :password => "password"})
        user0.save
        day_before_yesterday = (Date.yesterday - 1)
        puts day_before_yesterday.strftime('%Y %m %d')
        task = Task.new({:description => "task0", :public => true, :user => user0, :due_at => day_before_yesterday})
        task.save
        tasks = Task.before_date({}, Date.yesterday)
        assert_not_nil tasks
        assert_equal 1, tasks.size
      end
      should "list all before yesterday for a particular user" do
        user0 = User.new({:username => "username", :password => "password"})
        user0.save
        user1 = User.new({:username => 'username0', :password => 'password'})
        user1.save
        
        day_before_yesterday = (Date.yesterday - 1)
        task = Task.new({:description => "task0", :public => true, :user => user0, :due_at => day_before_yesterday})
        task.save
        task = Task.new({:description => "task1", :public => true, :user => user1, :due_at => day_before_yesterday})
        task.save
        tasks = Task.before_date({}, Date.yesterday)
        assert_not_nil tasks
        assert_equal 2, tasks.size
        tasks = Task.before_date({:user => user0}, Date.yesterday)
        assert_not_nil tasks
        assert_equal 1, tasks.size
        tasks = Task.before_date({:user => user1}, Date.yesterday)
        assert_not_nil tasks
        assert_equal 1, tasks.size
      end
        should "destroy all" do
          Task.destroy_all
          assert_equal 0, Task.all.length
        end
    end
    end
  end
end
