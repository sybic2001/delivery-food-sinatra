require_relative '../views/meals_view'

class MealsController

  def initialize(attributes ={})
    @meals_repository = attributes[:meals_repository]
    @employees_repository = attributes[:employees_repository]
    @customers_repository = attributes[:customers_repository]
    @orders_repository = attributes[:orders_repository]
    @view = MealsView.new
  end

  def add_meal
    name = @view.ask_for("Name ?")
    price = @view.ask_for("Price ?")
    meal = Meal.new(name: name, price: price)
    @meals_repository.add_meal(meal)
  end

  def list_all_meals
    @view.list_all_meals(@meals_repository.meals)
  end

  def remove_meal
    @view.list_all_meals(@meals_repository.meals)
    index = @view.ask_for("Index ?").to_i - 1
    id = @meals_repository.meals[index].id
    unless @orders_repository.orders.select { |item| item.meal.id == id }.empty?
      puts "Impossible, undelivered orders in progress !"
    else
      @meals_repository.remove_meal_at(index)
    end
  end
end
