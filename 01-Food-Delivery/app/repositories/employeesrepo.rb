require 'csv'
require_relative '../models/employee'

class EmployeesRepo

  attr_reader :employees

  def initialize(csv_file)
    @csv_file = csv_file
    @employees = []
    load
  end

  def find(id)
    return @employees.select { |employee| employee.id == id }.first
  end

  private

  def load
    CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
      @employees << Employee.new(id: row[:id].to_i, name: row[:name], manager: row[:manager] == "true", login: row[:login], pwd: row[:pwd])
    end
  end

end
