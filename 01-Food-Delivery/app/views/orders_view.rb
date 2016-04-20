class OrdersView

  def ask_for(stuff)
    puts stuff
    print "> "
    return gets.chomp
  end

  def list_undelivered_orders(orders)
    orders.each_with_index do |order, index|
      puts "#{index + 1}. Deliver : #{order.meal.name} For : #{order.customer.name} To : #{order.customer.address} By : #{order.employee.name}"
    end
  end

end
