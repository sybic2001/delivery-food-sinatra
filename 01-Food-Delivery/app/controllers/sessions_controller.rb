class SessionsController

  def initialize(employees_repository)
    @sessions_view = SessionsView.new
    @employees_repository = employees_repository
  end

  def log_in
    username = @sessions_view.ask_for("Username ?")
    password = @sessions_view.ask_for("Password ?")
    employee = @employees_repository.find_by_username(username)

  end

end
