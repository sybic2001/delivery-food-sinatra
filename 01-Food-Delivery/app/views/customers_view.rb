class CustomersView

  def ask_for(stuff)
    puts stuff
    print "> "
    return gets.chomp
  end

  def list_all_customers(customers)
    customers.each_with_index do |customer, index|
      puts "#{index + 1}. #{customer.name} - #{customer.address}"
    end
  end

end
