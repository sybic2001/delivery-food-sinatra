class Employee

  attr_accessor :id
  attr_reader :name, :manager, :login, :pwd

  def initialize (attributes = {})
    @name = attributes[:name]
    @login = attributes[:login]
    @pwd = attributes[:pwd]
    @manager = attributes[:manager]
    @id = attributes[:id]
  end

end
