# TODO: implement the router of your app

class Router

  def initialize(attributes = {})
    @employees_controller = attributes[:employees_controller]
    @meals_controller = attributes[:meals_controller]
    @customers_controller = attributes[:customers_controller]
    @orders_controller = attributes[:orders_controller]
    @employee_logged_in = nil
  end

  def run

    loop do
      @employee_logged_in = @employees_controller.log_in
      if @employee_logged_in.nil?
        puts "Wrong combination !"
        next
      end
      if @employee_logged_in.manager
        run_as_manager
      else
        run_as_delivery
      end
    end
  end

  def run_as_manager
    loop do
      puts "What do you want to do ? Type index !
      1. View all meals
      2. Add a meal
      3. Delete a meal
      4. View all customers
      5. Add a customer
      6. Delete a customer
      7. View undelivered orders
      8. Add an order
      9. Log out"
      print "> "
      index = gets.chomp.to_i
      case index
      when 1 then @meals_controller.list_all_meals
      when 2 then @meals_controller.add_meal
      when 3 then @meals_controller.remove_meal
      when 4 then @customers_controller.list_all_customers
      when 5 then @customers_controller.add_customer
      when 6 then @customers_controller.remove_customer
      when 7 then @orders_controller.list_undelivered_orders
      when 8 then @orders_controller.add_order
      when 9 then break
      else puts "I did not get your point !"
      end
    end
  end

  def run_as_delivery
    loop do
      puts "What do you want to do ? Type index !
      1. View my undelivered orders
      2. Mark an order as delivered
      3. Log out"
      print "> "
      index = gets.chomp.to_i
      case index
      when 1 then @orders_controller.list_my_undelivered_orders(@employee_logged_in.id)
      when 2 then @orders_controller.mark_order_as_delivered(@employee_logged_in.id)
      when 3 then break
      else puts "I did not get your point !"
      end
    end
  end

end
