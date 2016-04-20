# TODO: require relevant files to bootstrap the app.
# Then you can test your program with:
#    $ ruby app.rb

require_relative 'app/models/meal'
require_relative 'app/models/customer'
require_relative 'app/models/employee'
require_relative 'app/models/order'
require_relative 'app/repositories/mealsrepo'
require_relative 'app/repositories/customersrepo'
require_relative 'app/repositories/ordersrepo'
require_relative 'app/repositories/employeesrepo'
require_relative 'app/controllers/meals_controller'
require_relative 'app/controllers/customers_controller'
require_relative 'app/controllers/employees_controller'
require_relative 'app/controllers/orders_controller'
require_relative 'router'
require 'sinatra'
set :bind, '0.0.0.0'

repo_meals = MealsRepo.new('app/repositories/meals.csv')
repo_customers = CustomersRepo.new('app/repositories/customers.csv')
repo_employees = EmployeesRepo.new('app/repositories/employees.csv')
repo_orders = OrdersRepo.new(csv_file: 'app/repositories/orders.csv', employeesrepo: repo_employees, customersrepo: repo_customers, mealsrepo: repo_meals)

meals_controller = MealsController.new(meals_repository: repo_meals, customers_repository: repo_customers, employees_repository: repo_employees, orders_repository: repo_orders)
customers_controller = CustomersController.new(meals_repository: repo_meals, customers_repository: repo_customers, employees_repository: repo_employees, orders_repository: repo_orders)
employees_controller = EmployeesController.new(meals_repository: repo_meals, customers_repository: repo_customers, employees_repository: repo_employees, orders_repository: repo_orders)
orders_controller = OrdersController.new(meals_repository: repo_meals, customers_repository: repo_customers, employees_repository: repo_employees, orders_repository: repo_orders)


# router = Router.new(meals_controller: meals_controller, customers_controller: customers_controller, employees_controller: employees_controller, orders_controller: orders_controller)

# router.run

get '/' do
  erb :home
end

get '/signin' do
  @error = params["error"] == "true"
  p @error
  erb :signin
end

post '/signin' do
  employee = employees_controller.signin(params)
  redirect '/signin?error=true' if employee.nil?
  redirect "/indexmanager/#{employee.login}" if employee.manager
  redirect "/indexdelivery/#{employee.login}"
end

get '/indexdelivery/:login' do |login|
  @login = login
  redirect "/indexdelivery/#{login}/deliverorders"
end

get '/indexdelivery/:login/deliverorders' do |login|
  @customers = repo_customers.customers
  @orders = repo_orders.orders
  @orders_undelivered = repo_orders.orders.select { |order| order.status == "undelivered" && order.employee.login == login.to_s }
  @employees = repo_employees.employees
  @meals = repo_meals.meals
  @login = login
  erb :deliverorders
end

post '/indexdelivery/:login/deliverorders/markdelivered' do |login|
  order_id = params.key("on").to_i
  repo_orders.mark_as_delivered!(order_id)
  redirect "/indexdelivery/#{login}/deliverorders"
end

get '/indexmanager/:login' do |login|
  @login = login
  erb :indexmanager
end

get '/indexmanager/:login/managemeals' do |login|
  @meals = repo_meals.meals
  @orders = repo_orders.orders
  @login = login
  erb :managemeals
end

post '/indexmanager/:login/managemeals/add' do |login|
  unless params["name"] == "" || params["price"] == "" then
    meal = Meal.new(name: params["name"], price: params["price"].to_i)
    repo_meals.add_meal(meal)
  end
  redirect "/indexmanager/#{login}/managemeals"
end

get '/indexmanager/:login/managecustomers' do |login|
  @customers = repo_customers.customers
  @orders = repo_orders.orders
  @login = login
  erb :managecustomers
end

post '/indexmanager/:login/managecustomers/add' do |login|
  unless params["name"] == "" || params["address"] == "" then
    customer = Customer.new(name: params["name"], address: params["address"])
    repo_customers.add_customer(customer)
  end
  redirect "/indexmanager/#{login}/managecustomers"
end

post '/indexmanager/:login/managecustomers/delete' do |login|
    customer_id = params.key("on").to_i
    if repo_orders.orders.select { |commande| commande.customer.id == customer_id && commande.status == "undelivered"}.empty?
      repo_orders.clean_orders_with_customer!(customer_id)
      repo_customers.remove_customer_id(customer_id)
    end
    redirect "/indexmanager/#{login}/managecustomers"
end

get '/indexmanager/:login/manageorders' do |login|
  @customers = repo_customers.customers
  @orders = repo_orders.orders
  @orders_undelivered = repo_orders.orders.select { |order| order.status == "undelivered" }
  @employees = repo_employees.employees
  @meals = repo_meals.meals
  @login = login
  erb :manageorders
end

post '/indexmanager/:login/manageorders/add' do |login|
  p params
  customer = repo_customers.find(params["customer"].to_i)
  meal = repo_meals.find(params["meal"].to_i)
  employee = repo_employees.find(params["employee"].to_i)
  order = Order.new(customer: customer, employee: employee, meal: meal)
  repo_orders.add_order(order)
  redirect "/indexmanager/#{login}/manageorders"
end

post '/indexmanager/:login/managemeals/delete' do |login|
    meal_id = params.key("on").to_i
    if repo_orders.orders.select { |commande| commande.meal.id == meal_id && commande.status == "undelivered"}.empty?
      repo_orders.clean_orders_with_meal!(meal_id)
      repo_meals.remove_meal_id(meal_id)
    end
    redirect "/indexmanager/#{login}/managemeals"
end

