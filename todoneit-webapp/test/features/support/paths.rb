module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /(start|home|index) page/
      "/"
    when /registration page/
      "/signup"
    when /new task page/
      "/tasks/new"
    when /login page/
      "/login"
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

World(NavigationHelpers)
