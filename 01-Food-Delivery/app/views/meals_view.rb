class MealsView

  def ask_for(stuff)
    puts stuff
    print "> "
    return gets.chomp
  end

  def list_all_meals(meals)
    meals.each_with_index do |meal, index|
      puts "#{index + 1}. #{meal.name} - #{meal.price} €"
    end
  end

end
