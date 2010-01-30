class Main
  get "/users/:username" do
    @user = ToDoneIt::User.first({:username => params[:username]})
    if @user
      @todo = @user.todo
      @completed = @user.completed
    end
    haml :"users/username"
  end

  get "/users/:username/delete" do
    require_login
    @user = ToDoneIt::User.first({:username => params[:username]})
    haml :"users/delete"
  end

  post "/users/:username/delete" do
    require_login
    if params[:confirm]
      @user = ToDoneIt::User.first({:username => params[:username]}).destroy!
      session[:user] = nil
      redirect '/'
    else
      redirect "/users/#{params[:username]}"
    end
  end
end
