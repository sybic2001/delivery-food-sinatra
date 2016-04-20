require_relative '../views/orders_view'
require_relative '../views/customers_view'
require_relative '../views/meals_view'
require_relative '../views/employees_view'
require_relative '../models/order'

class OrdersController

  def initialize(attributes ={})
    @meals_repository = attributes[:meals_repository]
    @employees_repository = attributes[:employees_repository]
    @customers_repository = attributes[:customers_repository]
    @orders_repository = attributes[:orders_repository]
    @orders_view = OrdersView.new
    @customers_view = CustomersView.new
    @employees_view = EmployeesView.new
    @meals_view = MealsView.new
  end

  def list_undelivered_orders
    undelivered_orders = @orders_repository.orders.select { |order| order.status == "undelivered" }
    @orders_view.list_undelivered_orders(undelivered_orders)
  end

  def list_my_undelivered_orders(employee_id)
    my_undelivered_orders = @orders_repository.orders.select { |order| order.employee.id == employee_id && order.status == "undelivered" }
    @orders_view.list_undelivered_orders(my_undelivered_orders)
  end

  def add_order
    @customers_view.list_all_customers(@customers_repository.customers)
    index_customer = @orders_view.ask_for("Index ?").to_i - 1
    @meals_view.list_all_meals(@meals_repository.meals)
    index_meal = @orders_view.ask_for("Index ?").to_i - 1
    @employees_view.list_all_employees(@employees_repository.employees)
    index_employee = @orders_view.ask_for("Index ?").to_i - 1
    order = Order.new(customer: @customers_repository.customers[index_customer], meal: @meals_repository.meals[index_meal], employee: @employees_repository.employees[index_employee])
    @orders_repository.add_order(order)
  end

  def mark_order_as_delivered(employee_id)
    my_undelivered_orders = @orders_repository.orders.select { |order| order.employee.id == employee_id && order.status == "undelivered" }
    @orders_view.list_undelivered_orders(my_undelivered_orders)
    index = @orders_view.ask_for("Index ?").to_i - 1
    id = my_undelivered_orders[index].id
    @orders_repository.mark_as_delivered!(id)
  end

end
