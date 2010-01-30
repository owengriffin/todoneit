require 'helper'

module ToDoneIt
  class TestTask < Test::Unit::TestCase
    context "model" do 
      setup do
        DataMapper.setup(:default, 'sqlite3::memory:')
        DataMapper.auto_migrate!
#          DataMapper::Logger.new(STDOUT, :debug)        
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
        should "list uncompleted tasks before completed" do
          user0 = User.new({:username => "username", :password => "password"})
          user0.save
          task0 = Task.new({:description => "task0", :public => true, :user => user0, :due_at => Date.today})
          task0.save
          task1 = Task.new({:description => "task1", :public => true, :user => user0, :due_at => Date.today, :completed_at => Date.today})
          task1.save
          tasks = Task.today({:user => user0})
          assert_equal 2, tasks.size
          assert_equal task1, tasks[1]
          assert_equal task0, tasks[0]
        end
        should "order tasks by priority" do
          user0 = User.new({:username => "username", :password => "password"})
          user0.save
          task0 = Task.new({:description => "task0", :public => true, :user => user0, :due_at => Date.today, :priority => 2})
          task0.save
          task1 = Task.new({:description => "task1", :public => true, :user => user0, :due_at => Date.today, :priority => 1})
          task1.save
          tasks = Task.today({:user => user0})
          assert_equal 2, tasks.size
          assert_equal task0, tasks[1]
          assert_equal task1, tasks[0]
        end
        should "destroy all" do
          Task.destroy_all
          assert_equal 0, Task.all.length
        end
    end
    end
  end
end
