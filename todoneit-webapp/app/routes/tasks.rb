# -*- coding: utf-8 -*-
class Main
  get "/tasks/new" do
    @task = ToDoneIt::Task.new
    haml :"tasks/new"
  end

  post "/tasks/new" do
    accept_login_or_signup
    
    @task = current_user.tasks.new(params[:task])
    
    if @task.save
      session[:notice] = "Your task has been added"
      redirect "/"
    else
      haml :"tasks/new"
    end
  end

  get "/tasks/:id/delete" do
    require_login
    @task = ToDoneIt::Task[params[:id]]
    haml :"tasks/delete"
  end

  post "/tasks/:id/delete" do
    require_login
    if params[:confirm]
      @task = ToDoneIt::Task.get(params[:id]).destroy!
      redirect '/'
    else
      redirect "/tasks/#{params[:id]}"
    end
  end

  post "/tasks/:id/complete" do
    require_login
    task = ToDoneIt::Task.get(params[:id])
    task.completed_at="now"
    if task.save
      JSON.generate({:message => "OK", :task_id => params[:id]})
    else
      JSON.generate({:message => "FAIL"})
    end
  end

  post "/tasks/:id/promote" do
    require_login
    task = ToDoneIt::Task.get(params[:id])
    if task.priority > 3
      task.priority = 3
    else
      task.priority = task.priority - 1 if task.priority > 1
    end
    if task.save
      JSON.generate({:message => "OK", :task_id => params[:id], :priority => task.priority})
    else
      JSON.generate({:message => "FAIL"})
    end
  end

  post "/tasks/:id/relegate" do
    require_login
    task = ToDoneIt::Task.get(params[:id])
    if task.priority > 2
      task.priority = 99
    else
      task.priority = task.priority + 1 if task.priority < 99
    end
    if task.save
      JSON.generate({:message => "OK", :task_id => params[:id], :priority => task.priority})
    else
      JSON.generate({:message => "FAIL"})
    end
  end

  get "/tasks/deleteall" do
    @tasks = ToDoneIt::Task.all
    logger.debug "Size =#{@tasks.size}"
    @tasks.each { |task|
      task.delete
    }
  end

  get "/tasks/timeline/:access/:period" do
    message = "No items found"
    logger.debug "Current user = #{current_user}"
    tasks = []
    pub = params[:access] == "public"
    logger.debug "Period = #{params[:period]}"
    logger.debug "Access = #{params[:access]}"
    if params[:period] == "today"
      if pub
        tasks = ToDoneIt::Task.today({:public => true})
      else
        tasks = current_user.today
      end
      message = "Nothing to do today. Sit back, put your feet up and RELAX!"
    elsif params[:period] == "yesterday"
      if pub
        tasks = ToDoneIt::Task.yesterday({:public => true})
      else
        tasks = current_user.yesterday
      end
      message = "You got away with it, nothing was done today."
    elsif params[:period] == "tomorrow"
      if pub
        tasks = ToDoneIt::Task.tomorrow({:public => true})
      else
        tasks = current_user.tomorrow
      end
      message = "Book a holiday - quickly!"
    elsif params[:period] == "previously"
      logger.debug "Doing it"
      
      tasks = ToDoneIt::Task.before_date({:user => current_user}, Date.yesterday)
      logger.debug "Tasks = #{tasks.inspect}"
      message = "Serious un-achiever, and proud of it. "
    elsif params[:period] == "sometime"
      logger.debug Date.tomorrow.strftime("%Y %M %d")
      tasks = ToDoneIt::Task.after_date({:user => current_user}, Date.tomorrow)
      message = "Who knows what the future will hold."
    end
    
    list(params[:period], tasks, message)
  end

  get "/tasks/:username/:period" do
    logger.debug "Username #{params[:username]}"
    user = User.find({:username => params[:username]}).first
    tasks = []
    if params[:period] == "today"
      tasks = ToDoneIt::Task.today({:user => user, :public => true})
    elsif params[:period] == "yesterday"
      tasks = ToDoneIt::Task.yesterday({:user => user, :public => true})
    end
    logger.info "Tasks = #{tasks.inspect}"
    list(params[:period], tasks)
  end

  get "/tasks/private/:year/:month/:day" do
    require_login
    tasks = ToDoneIt::Task.date({:user => current_user.id}, Date.civil(params[:year].to_i, params[:month].to_i, params[:day].to_i))
    list("#{params[:year]}/#{params[:month]}/#{params[:day]}", tasks)
  end

  get "/tasks/:id" do
    @task = ToDoneIt::Task.get(params[:id])
    @author = @task.user
    @url = @task.location
    haml :"tasks/id"
  end

  module Helpers

    def friendly_date(date)
      today = Date.today

      case date
      when today - 1
        "Yesterday"
      when today
        "Today"
      when today + 1
        "Tomorrow"
      else
        dow = DAYS[date.wday]

        if date.year == today.year
          if date.month == today.month
            "#{dow} #{date.strftime "%d"}"
          else
            "#{dow} #{date.strftime "%d/%m"}"
          end
        else
          "#{dow} #{date.strftime "%d/%m/%y"}"
        end
      end
    end

    def list(title, tasks, message = "Shh.. Nothing found - be quiet or someone will assign you something.")
      partial(:"tasks/list", :title => title, :tasks => tasks, :message => message)
    end
  end

  include Helpers
end
