require 'csv'
require_relative '../models/order'
require_relative '../models/meal'
require_relative '../models/employee'
require_relative '../models/customer'

class OrdersRepo

  attr_reader :orders

  def initialize(arguments = {})
    @csv_file = arguments[:csv_file]
    @orders = []
    @next_id = 0
    @employeesrepo = arguments[:employeesrepo]
    @customersrepo = arguments[:customersrepo]
    @mealsrepo = arguments[:mealsrepo]
    load
  end

  def add_order(order)
    order.id!(@next_id)
    @next_id += 1
    @orders << order
    save
  end

  def find(id)
    return @orders.select { |item| item.id == id }.first
  end

  def mark_as_delivered!(id)
    find(id).mark_as_delivered!
    save
  end

  def clean_orders_with_meal!(meal_id)
    @orders.delete_if { |order| order.meal.id == meal_id && order.status == "delivered"}
    save
  end

  def clean_orders_with_customer!(customer_id)
    @orders.delete_if { |order| order.customer.id == customer_id && order.status == "delivered"}
    save
  end

  private

  def load
    CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
      if row[:status].nil?
        @next_id = row[:id].to_i
      else
        meal = @mealsrepo.find(row[:meal_id].to_i)
        customer = @customersrepo.find(row[:customer_id].to_i)
        employee = @employeesrepo.find(row[:employee_id].to_i)
        @orders << Order.new(id: row[:id].to_i, customer: customer, meal: meal, employee: employee, status: row[:status])
      end
    end
  end

  def save
    CSV.open(@csv_file, 'wb') do |csv|
      csv << ["id", "customer_id", "meal_id", "employee_id", "status"]
      @orders.each do |order|
        csv << [order.id, order.customer.id, order.meal.id, order.employee.id, order.status]
      end
      csv << [@next_id]
    end
  end
end
