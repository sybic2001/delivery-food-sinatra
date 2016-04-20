class Order

  attr_reader :meal, :customer, :employee, :status, :id

  def initialize(attributes = {})
    @customer = attributes[:customer]
    @meal = attributes[:meal]
    @employee = attributes[:employee]
    @status = attributes[:status] || "undelivered"
    @id = attributes[:id] || nil
  end

  def id!(id)
    @id = id
  end

  def mark_as_delivered!
    @status = "delivered"
  end

end
