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


# fourth way to solve this by separating abstract from concrete

class Bicycle

  def initialize(**opts)
    @size      = opts[:size]
    @chain     = opts[:chain]
    @tire_size = opts[:tire_size]
  end

  def spares
    { front_shock: 'Manitou',
      rear_shock: 'Fox'}
  end


end



class RoadBike < Bicycle

  def initialize(**opts)
    @tape_color = opts[:tape_color]
  end

  def spares
    { chain: '11-speed',
      tire_size: '23',
      tape_color: 'red'}
  end

end

class MountainBike < Bicycle

  def spares
    super.merge(front_shock: front_shock)
  end

end

puts mountain_bike.spares # it will throw no super class method



# fifth method to solve problems of related types that share behavior

# this is the method called implementig template method

class Bicycle

  attr_reader :size, :chain, :tire_size

  def initialize(**opt)
    @size = opts[:size]
    @chain = opts[:chain]
    @tire_size = opts[:tire_size]
  end

  def spares
    { tire_size: tire_size,
      chain:     chain
    }
  end

  def default_chain
    '11-speed'
  end

  def default_tire_size
    raise NoImplementedError
  end
end

class RoadBike < Bicycle

  attr_reader :tape_color

  def initialize(**opts)
    @tape_color = opts[:tape_color]
    super
  end

  def spares
    super.merge(tape_color: tape_color)
  end

  def default_tire_size
    '23'
  end

end

class MountainBike

  attr_reader :front_shock, :rear_shock

  def initialize(**opts)
    @front_shock = front_shock
    @rear_shock = rear_shock
    super
  end

  def spares
    super.merge(front_shock: front_shock)
  end

  def default_tire_size
    '2.1'
  end


end

# in case a new class must be added there would be no problem if programmer forgets super

class RecumbentBike < Bicycle

  attr_reader :flag

  def initiliaze(**opts)
    flag = opts[:flag]
  end

  def spares
    super.merge(flag: flag)
  end

  def default_chain
    '10-speed'
  end

  def default_tire_size
    '28'
  end
end

bent = RecumbentBike.new(flag: 'tall and orage')
puts bent.spares



# last method is decoupling subclass using Hook Messages


class Bicycle

  attr_reader :size, :chain, :tire_size

  def initialize(**opts)
    @size      = opts[:size]
    @chain     = opts[:chain]     || default_chain
    @tire_size = opts[:tire_size] || default_tire_size
    post_initialize(opts)
  end

  def spares
    { tire_size: tire_size,
      chain: chain }.merge(local_spares)
  end

  def default_tire_size
    raise NoImplementedError
  end

  def default_chain
    '11-speed'
  end

  def post_initialize(opts)
  end

  def local_spares
    {}
  end
end


class RoadBike < Bicycle

  attr_reader :tape_color

  def post_initialize(**opts)
    @tape_color = opts[:tape_color]
  end

  def local_spares
    { tape_color: tape_color }
  end

  def default_tire_size
    '23'
  end

end


class MountainBike < Bicycle

  attr_reader :front_shock, :rear_shock

  def post_initialize(**opts)
    @front_shock = opts[:front_shock]
    @rear_shock = opts[:rear_shock]

  end

  def local_spares
    { front_shock: front_shock }
  end

  def default_tire_size
    '2.1'
  end

end

road_bike = RoadBike.new(
              size: 'M',
              tape_color: 'red')

puts road_bike.tire_size # 23
puts road_bike.chain # 11-speed
puts road_bike.spares # tire_size: 23, chain: 11-speed, tapre_color: red


mountain_bike = MountainBike.new(
                  size: 'M',
                  front_shock: 'Manitou',
                  rear_shock: 'Fox')

puts mountain_bike.tire_size # 2.1
puts mountain_bike.chain # 11-speed
puts mountain_bike.spares # tire_size: 2.1, chain: 11-speed, front_shock: 'Manitou'












