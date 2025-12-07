class Parent
  attr_reader :name

  def initialize
    @name = 'RUG::B'
  end
end

class Child < Parent
  attr_reader :month

  def initialize(month)
    super()
    @month = month
  end

  def <=>(other)
    return nil unless other.is_a?(Child)
    self.month <=> other.month
  end
end

c1 = Child.new(12)
c2 = Child.new(13)

puts [c2, c1].sort
