# 6th chapter covers the main clues to identify when to use inheritance.


# Well-designed applications are constructed of reusable code; small, trustworthy, self-cotained objects with minimal context, clear interfaces and injected dependencies are inherently reusable.

# Inheritance is at its core a mechanism for automatic message delegation.

class Bycicle

  attr_reader :size, :tape_color

  def initialize(**opts)
    @size       = opts[:size]
    @tape_color = opts[:tape_color]
  end



  def spares
    { chain: '11-speed',
      tire_size: '23',
      tape_color: tape_color }
  end

end

bike = Bycicle.new(
        size: 'M',
        tape_color: 'red')

puts bike.size

puts bike.spares



# first method to solve the issue without inheritance, this is adding code to the class.


class Bicycle
  attr_reader :style, :size,
              :tape_color,
              :front_shock, :rear_shock

  def initialize(**opts)
    @style       = opts[:style]
    @size        = opts[:size]
    @tape_color  = opts[:tape_color]
    @front_shock = [:front_shock]
    @rear_shock  = [:rear_shock]

  end


  def spares
    if style == :road
      { chain :     '11-speed',
        tire_size:  '23',
        tape_color: tape_color }
    else
      { chain: '11-sped',
        tire_size: '2.1',
        front_shock: front_shock }
    end
  end

end


bike_1 = Bycicle.new(
        style: :mountain,
        size: 'S',
        front_shock: 'Manitou',
        rear_shock: 'Fox')

puts bike_1.spares

bike_2 = Bycicle.new(
        style: :road,
        size: 'M',
        tape_color: 'red')

puts bike_2.spares














