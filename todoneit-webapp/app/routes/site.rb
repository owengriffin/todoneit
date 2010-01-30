class Main
  get "/" do
    if logged_in?
      session[:title]="Your task list"
    else
      session[:title]="Public list"
    end
    haml :home
  end
end
