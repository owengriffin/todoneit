class Main
  get "/login" do
    haml :"login"
  end

  post "/login" do
    begin
      authenticate(params)
      redirect "/"
    rescue ToDoneIt::User::WrongUsername, ToDoneIt::User::WrongPassword
      session[:error] = "We are sorry: the information supplied is not valid."
      haml :"login"
    end
  end

  get "/logout" do
    session[:user] = nil
    redirect "/"
  end

  get "/signup" do
    @user = ToDoneIt::User.new

    haml :"signup"
  end

  post "/signup" do
    @user = signup(params[:user])

    if @user.id
      redirect "/", 303
    else
      haml :"signup"
    end
  end

  helpers do
    def require_login
      if session[:user]
        return true
      else
        session[:return_to] = request.fullpath
        redirect "/login"
        return false
      end
    end

    def authenticate(params)
      session[:user] = ToDoneIt::User.authenticate(params[:username], params[:password]).id
    end

    def signup(params)
      user = ToDoneIt::User.new(params)

      if user.save
        session[:user] = user.id
      end

      user
    end

    def authenticate_or_signup(params)
      if params.delete("existing") == "1"
        authenticate(params)
      else
        signup(params)
      end
    end

    def current_user
      return @current_user ||= ToDoneIt::User.get(session[:user]) if session[:user]
    end

    def redirect_to_stored
      if return_to = session[:return_to]
        session[:return_to] = nil
        redirect return_to
      else
        redirect "/"
      end
    end

    def logged_in?
      !! current_user
    end

    def ensure_current_account(username)
      halt 404 unless current_user && current_user.username == username
    end

    def accept_login_or_signup
      if params[:session]
        begin
          authenticate_or_signup(params[:session])
        rescue ToDoneIt::User::WrongUsername, ToDoneIt::User::WrongPassword
        end
      end
    end
  end
end
