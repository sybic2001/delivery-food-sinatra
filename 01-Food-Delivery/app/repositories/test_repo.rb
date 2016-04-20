require_relative '../models/meal'
require_relative '../models/customer'
require_relative '../models/employee'
require_relative '../models/order'
require_relative 'mealsrepo'
require_relative 'customersrepo'
require_relative 'ordersrepo'
require_relative 'employeesrepo'


repo_meals = MealsRepo.new('meals.csv')
# meal1 = Meal.new(name: "Big Mac", price: 50)
# meal2 = Meal.new(name: "Pates", price: 30)
# meal3 = Meal.new(name: "Pizza", price: 100)

# repo_meals.add_meal(meal1)
# repo_meals.add_meal(meal2)
# repo_meals.add_meal(meal3)

repo_customers = CustomersRepo.new('customers.csv')
# customer1 = Customer.new(name: "Paul", address: "Villa Gaudelet")
# customer2 = Customer.new(name: "Philippe", address: "Rue des Martyrs")
# customer3 = Customer.new(name: "Nadia", address: "Rue Mary Besseyre")

# repo_customers.add_customer(customer1)
# repo_customers.add_customer(customer2)
# repo_customers.add_customer(customer3)

repo_employees = EmployeesRepo.new('employees.csv')

repo_orders = OrdersRepo.new(csv_file: 'orders.csv', employeesrepo: repo_employees, customersrepo: repo_customers, mealsrepo: repo_meals)

order1 = Order.new(customer: repo_customers.find(2), meal: repo_meals.find(2), employee: repo_employees.find(0))

repo_orders.add_order(order1)

