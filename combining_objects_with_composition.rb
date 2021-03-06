# 8th chapter composition allows you to combine small parts to create more complex objets such that the whole becomes more than the sum of its parts.

# Those objets tend to consist of simple, discrete entities that can easily be rearranged into a new combinations.


# Also can be easy to understand, reuse and test.


class Bicycle

  attr_reader :size, :parts

  def initialize(size, parts)
    @parts = parts
    @size  = size
  end


  def spares
    parts.spares
  end

end


class Parts

  attr_reader :chain, :tire_size

  def initialize(**opts)
    @chain     = opts[:chain]     || default_chain
    @tire_size = opts[:tire_size] || default_tire_size
    post_initialize(opts)
  end

  def spares
    { chain:      chain,
      tire_size : tire_size }.merge(local_spares)
  end

  def local_spares
    {}
  end

  def default_tire_size
    raise NoImplemented_error
  end

  # subclass may be override
  def post_initialize(opts)
    nil
  end

  def default_chain
    '11-speed'
  end

end

class RoadBikeParts < Parts

  attr_reader :tape_color

  def post_initialize(**opts)
    @tape_color = opts[:tape_color]
  end

  def local_spares
    { tape_color: tape_color}
  end

  def default_tire_size
    '23'
  end
end


class MountainBikeParts < Parts

  attr_reader :front_shock, :rear_schock

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

road_bike = Bicycle.new(
            size: 'L',
            parts: RoadBikeParts.new(tape_color: 'red'))

puts road_bike.size
# => L

puts   road_bike.spares
# => {:chain => '11-speed', :tire_size => '23', :tape_color => 'red'}


mountain_bike = Bicycle.new(
                  size: 'L',
                  parts: MountainBikeParts.new(
                          front_shock: 'Manitou',
                          rear_shock: 'Fox')
                  )

puts mountain_bike.size
# => L

puts mountain_bike.parts
# => {:chain => '11-speed', :tire_size => '2.1', :front_schock => 'Manitou'}



# first attempt by composing the Parts Object



class Bicycle

  attr_reader :size, :parts

  def initialize(size, parts)
    @parts = parts
    @size  = size
  end


  def spares
    parts.spares
  end

end

require 'forwardable'

class Parts < Array
  extend Forwardable
  def_delegators :@parts, :size, :each
  include Enumerable
  attr_reader :parts

  def initialize(parts)
    @parts = parts
  end


  def spares
    select { |part| part.needs_spare}
  end

  def size
    parts.size
  end

end


class Part

  attr_reader :name, :description, :needs_spare

  def initialize(name, description, needs_spare: true)
    @name        = name
    @description = description
    @needs_spare = needs_spare
  end

end


chain =
  Part.new(name: 'chain', description: '11-speed')

road_tire =
  Part.new(name: 'tire_size', description: '23')

tape =
  Part.new(name: 'tape_color', description: 'red')

mountain_tire =
  Part.new(name: 'tire_size', description: '2.1')

rear_schock =
  Part.new(name: 'rear_schock', description: 'Fox', needs_spare: false)

front_schock =
  Part.new(name: 'front_schock', description: 'Manitou')


road_bike_parts =
    Parts.new(chain, road_tire, tape)

road_bike =
  Bicycle.new(
    size: 'L',
    parts: Parts.new([chain,
                      road_bike,
                      tape]))

puts road_bike.size
# => L

puts road_bike.spares.inspect


mountain_bike =
  Bicycle.new(
    size: 'L',
    parts: Parts.new([chain,
                      mountain_tire,
                      front_shock,
                      rear_shock]))
puts mountain_bike.size
# => L

puts mountain_bike.spares.inspect


combo_parts =
  ( mountain_bike.parts + road_bike.parts )

puts mountain_bike.parts.class # => Parts
puts road_bike.parts.class     # => Parts
puts combo_parts.class         # => Array



# 2nd attempt now using module


road_config =
  [['chain',      '11-speed'],
   ['tire_size',  '23'],
   ['tape_color', 'red']]

mountain_config =
  [['chain',       '11-speed'],
   ['tire_size',   '2.1'],
   ['front_shock', 'Manitou'],
   ['rear_shock',  'Fox', false]]

module PartsFactory

  def self.build(config:,
                  part_class: Parts,
                  parts_classL Parts)

    parts_class.new(
      config.collect{ |part_config|
        part_class.new(
          name:        part_config[0],
          description: part_config[1],
          needs_spare: part_config.fetch(2,true))})
  end
end

puts PartsFactory.build(config: road_config).inspect


puts PartsFactory.build(config: mountain_config).inspect


# 3rd attempt now using Open Struct


require 'ostruct'

module PartsFactory
  def self.build(config:, parts_class: Parts)
    parts_class.new(
      config.collect{ |part_config|
        create_part(part_config)})
  end

  def self.create_part(part_config)
    OpenStruct.new(
      name:        part_config[0],
      description: part_config[1],
      needs_spare: part_config.fetch(2,true))
  end
end


mountain_bike =
  Bicycle.new(
    size: 'L',
    parts: PartsFactory.build(config: mountain_config))

puts mountain_bike.class
# => Array

puts mountain_bike.spares


# all togeter

class Bicycle
  attr_reader :size, :parts

  def initialize(size:, parts:)
    @size  = size
    @parts = parts
  end

  def spares
    parts.spares
  end
end

require 'forwardable'

class Parts
  extend Forwardable
  def_delegators :@parts, :size, :each
  include Enumerable

  def initialize(parts)
    @parts = parts
  end

  def spares
    select {|part| part.needs_spare }
  end
end

require 'ostruct'
module PartsFactory


  def self.building(config:, parts_class: Parts)
    parts_class.new(
      config.collect{ |part_config|
        create_part(part_config)})
  end

  def self.create_part(part_config)
    OpenStruct.new(
      name:        part_config[0],
      description: part_config[1],
      needs_spare: part_config.fetch(2,true))
  end
end

road_config =
  [['chain', '11-speed'],
   ['tire_size', '23'],
   ['tape_color', 'red']]

mountain_config =
  [['chain',       '11-speed'],
   ['tire_size',   '2.1'],
   ['front_shock', 'Manitou'],
   ['rear_shock',  'Fox', false]]

road_bike =
  Bicycle.new(
    size: 'L',
    parts: PartsFactory.build(config: road_config))

puts road_bike.spares
# => #<OpenStruct
# =>    name='chain',
# =>    description='11-speed',
# =>    needs_spare=true>
# => #<OpenStruct
# =>    name='tire_size',
# =>    description='23',
# =>    needs_spare=true>
# => #<OpenStruct
# =>    name='tape_color',
# =>    description='red',
# =>    needs_spare=true>

mountain_bike =
  Bicycle.new(
    size: 'L',
    parts: PartsFactory.build(config: mountain_config))

puts mountain_bike.spares
# => #<OpenStruct
# =>    name='chain',
# =>    description='11-speed',
# =>    needs_spare=true>
# => #<OpenStruct
# =>    name='tire_size',
# =>    description='2.1',
# =>    needs_spare=true>
# => #<OpenStruct
# =>    name='front_schock',
# =>    description='Manitou',
# =>    needs_spare=true>



# adding a new sub class


recumbent_config =
  [['chain', '9-speed'],
   ['tire_size', '28'],
   ['flag', 'tall and orange']]

recumbent_bike =
    Bicycle.new(
      size: 'L',
      parts: PArtsFactory.build(config: recumbent_config))

puts recumbent_bike.spares
# => #<OpenStruct
# =>    name='chain',
# =>    description='9-speed',
# =>    needs_spare=true>
# => #<OpenStruct
# =>    name='tire_size',
# =>    description='28',
# =>    needs_spare=true>
# => #<OpenStruct
# =>    name='flag',
# =>    description='tall and orange',
# =>    needs_spare=true>


# Classical inheritance is a code arrangement technique. Behavior is dispersed among objects and these objects are organized into class relationships such as that automatic delegation of messages invokes the correct behavior.

# Composition allows objects to have structured independece but at the cost of explicit message delegation

# Composition contains far fewer built-in dependencies than inheritance; it is very often the best choice.

# Inheritance is a better solution when its use provides high rewards for low risk.



