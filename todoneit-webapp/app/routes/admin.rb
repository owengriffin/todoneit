# -*- coding: utf-8 -*-
class Main
  get "/admin/destroyall" do
    ToDoneIt::User.destroy_all
    ToDoneIt::Task.destroy_all
    haml :"admin/destroyall"
  end
  get "/admin/dummydata" do
    ToDoneIt::User.destroy_all
    ToDoneIt::Task.destroy_all
    user = ToDoneIt::User.new({:username => "owengriffin", :email_address => "owen.griffin@gmail.com", :password => "password"})
    user.save
    5.times { |i|
      ToDoneIt::Task.new({:description => "Task #{i}", :due_at => Date.today, :user => user}).save
    }
    5.times { |i|
      ToDoneIt::Task.new({:description => "Task #{i}", :due_at => Date.yesterday, :user => user}).save
    }
    5.times { |i|
      ToDoneIt::Task.new({:description => "Task #{i}", :due_at => Date.tomorrow, :user => user}).save
    }
    5.times { |i|
      ToDoneIt::Task.new({:description => "Task #{i}", :due_at => Date.tomorrow + i, :user => user}).save
    }
    5.times { |i|
      ToDoneIt::Task.new({:description => "Task #{i}", :due_at => Date.yesterday - i - 1, :user => user}).save
    }
    haml :"admin/dummydata"
  end
end
