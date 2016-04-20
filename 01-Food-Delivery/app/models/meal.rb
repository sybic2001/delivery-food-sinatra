class Meal

  attr_accessor :id
  attr_reader :name, :price

  def initialize (attributes = {})
    @name = attributes[:name]
    @price = attributes[:price]
    @id = attributes[:id]
  end

end
