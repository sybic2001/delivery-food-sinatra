require 'csv'
require_relative '../models/customer'

class CustomersRepo

  attr_reader :customers

  def initialize(csv_file)
    @csv_file = csv_file
    @customers = []
    @next_id = 0
    load
  end

  def add_customer(customer)
    customer.id = @next_id
    @next_id += 1
    @customers << customer
    save
  end

  def remove_meal_at(index)
    @customers.delete_at(index)
    save
  end

  def remove_customer_id(id)
    @customers.delete_if { |customer| customer.id == id }
    save
  end

  def find(id)
    return @customers.select { |customer| customer.id == id }.first
  end

  private

  def load
    CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
      if row[:name].nil?
        @next_id = row[:id].to_i
      else
        @customers << Customer.new(name: row[:name], address: row[:address], id: row[:id].to_i)
      end
    end
  end

  def save
    CSV.open(@csv_file, 'wb') do |csv|
      csv << ["id", "name", "address"]
      @customers.each do |customer|
        csv << [customer.id, customer.name, customer.address]
      end
      csv << [@next_id]
    end
  end
end
