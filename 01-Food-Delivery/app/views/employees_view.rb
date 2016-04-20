require 'io/console'

class EmployeesView

  def ask_for(stuff)
    puts stuff
    print "> "
    return gets.chomp
  end

  def ask_for_hidden(stuff)
    puts stuff
    print "> "
    return STDIN.noecho(&:gets).chomp
  end

  def list_all_employees(employees)
    employees.each_with_index do |employee, index|
      dispo = employee.manager ? "[MNG]" : "[   ]"
      puts "#{dispo} #{index + 1}. #{employee.name}"
    end
  end

end
