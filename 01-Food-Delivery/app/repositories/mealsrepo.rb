require 'csv'
require_relative '../models/meal'

class MealsRepo

  attr_reader :meals

  def initialize(csv_file)
    @csv_file = csv_file
    @meals = []
    @next_id = 0
    load
  end

  def add_meal(meal)
    meal.id = @next_id
    @next_id += 1
    @meals << meal
    save
  end

  def remove_meal_at(index)
    @meals.delete_at(index)
    save
  end

  def remove_meal_id(id)
    @meals.delete_if { |meal| meal.id == id }
    save
  end

  def find(id)
    return @meals.select { |meal| meal.id == id }.first
  end

  private

  def load
    CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
      if row[:name].nil?
        @next_id = row[:id].to_i
      else
        @meals << Meal.new(name: row[:name], price: row[:price].to_i, id: row[:id].to_i)
      end
    end
  end

  def save
    CSV.open(@csv_file, 'wb') do |csv|
      csv << ["id", "name", "price"]
      @meals.each do |meal|
        csv << [meal.id, meal.name, meal.price]
      end
      csv << [@next_id]
    end
  end

end
