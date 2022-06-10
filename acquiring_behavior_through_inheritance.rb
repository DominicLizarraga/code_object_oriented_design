# 6th chapter covers the main clues to identify when to use inheritance.


# Well-designed applications are constructed of reusable code; small, trustworthy, self-cotained objects with minimal context, clear interfaces and injected dependencies are inherently reusable.

# Inheritance is at its core a mechanism for automatic message delegation.

class Bicycle

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


bike_1 = Bicycle.new(
        style: :mountain,
        size: 'S',
        front_shock: 'Manitou',
        rear_shock: 'Fox')

puts bike_1.spares

bike_2 = Bicycle.new(
        style: :road,
        size: 'M',
        tape_color: 'red')

puts bike_2.spares


# second attempt to solve this by creating a new subclass

class MountainBike < Bycicle

  attr_reader :front_shock, :rear_shock

  def initialize(front_shock, rear_shock)
    @front_shock = front_shock
    @rear_shock = rear_shock
    super
  end

  def spares
    super merge(front_shock: front_shock)
  end

end

mountain_bike = MountainBike.new(
                  size: 'S',
                  front_shock: 'Manitou',
                  rear_shock: 'Fox')

puts mountain_bike.size


puts mountain_bike.spares # this will print tire_size and tape_color which is wrong


# third way to resolve inheritance issue, this time by creting an abstract class

class Bicycle
  attr_reader :size

  def initialize(**opts)
    @size = opts[:size]
  end

end

class RoadBike < Bycicle
  attr_reader :tape_color

  def initialize(**opts)
    @tape_color = opts[:tape_color]
    super

  end

end

class MountainBike < Bicycle

  attr_reader :front_shock, :rear_shock

  def initialize(front_shock, rear_shock)
    @front_shock = front_shock
    @rear_shock = rear_shock
    super
  end

end

road_bike = RoadBike.new(
              size:       'M',
              tape_color: 'red')

mountain_bike = MountainBike.new(
                  size: 'S',
                  front_shock: 'Manitou',
                  rear_shock: 'Fox')

puts road_bike.size

puts mountain_bike.size

