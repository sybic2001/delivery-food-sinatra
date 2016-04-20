require_relative '../models/meal'
require_relative '../views/employees_view'

class EmployeesController

  def initialize(attributes ={})
    @meals_repository = attributes[:meals_repository]
    @employees_repository = attributes[:employees_repository]
    @customers_repository = attributes[:customers_repository]
    @orders_repository = attributes[:orders_repository]
    @view = EmployeesView.new
  end

  def log_in
    login = @view.ask_for("Login?")
    pwd = @view.ask_for_hidden("Password?")
    return @employees_repository.employees.select { |employee| employee.login == login && employee.pwd == pwd }.first
  end

  def signin(param)
    return @employees_repository.employees.select { |employee| employee.login == param[:item][0] && employee.pwd == param[:item][1] }.first
  end

end
