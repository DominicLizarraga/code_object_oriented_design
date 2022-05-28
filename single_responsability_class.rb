# 2nd chapter of the book that covers class with a single responsability

class Gear

  attr_reader :chainring, :cog, :rim

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @wheel = Wheel.new(rim, tire)
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end

  Wheel = Struct.new(:rim, :tire)
    def diameter
      rim (tire * 2)
    end
  end

end

# ***** refactoring applying single responsability class ******


class Gear

  attr_reader :chainring, :cog, :wheel

  def initialize(chainring, cog, wheel=nil)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end

end

class Wheel

  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim + (tire * 2)
  end

  def circumference
    diameter * Math::PI
  end


end

@wheel = Wheel.new(26, 1.5)
puts @wheel

puts Gear.new(52, 11, @wheel).gear_inches

puts Gear.new(51, 11).ratio

# the path to changeable and maintainable object-oriented software begins with classes that have a single responsability







