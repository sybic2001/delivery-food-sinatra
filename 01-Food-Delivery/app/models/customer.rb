class Customer

  attr_accessor :id
  attr_reader :name, :address

  def initialize(attributes = {})
    @name = attributes[:name]
    @address = attributes[:address]
    @id = attributes[:id]
  end

end
