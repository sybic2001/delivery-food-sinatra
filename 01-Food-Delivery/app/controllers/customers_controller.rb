require_relative '../views/customers_view'
require_relative '../models/customer'

class CustomersController

  def initialize(attributes ={})
    @meals_repository = attributes[:meals_repository]
    @employees_repository = attributes[:employees_repository]
    @customers_repository = attributes[:customers_repository]
    @orders_repository = attributes[:orders_repository]
    @view = CustomersView.new
  end

  def add_customer
    name = @view.ask_for("Name ?")
    address = @view.ask_for("Address ?")
    customer = Customer.new(name: name, address: address)
    @customers_repository.add_customer(customer)
  end

  def list_all_customers
    @view.list_all_customers(@customers_repository.customers)
  end

  def remove_customer
    @view.list_all_customers(@customers_repository.customers)
    index = @view.ask_for("Index ?").to_i - 1
    id = @customers_repository.customers[index].id
    unless @orders_repository.orders.select { |item| item.customer.id == id }.empty?
      puts "Impossible, undelivered orders in progress !"
    else
      @customers_repository.remove_meal_at(index)
    end
  end

end
