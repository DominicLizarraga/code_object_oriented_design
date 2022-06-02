# 3rd chapter of the book that covers managing dependencies

# Because well desgined objects hace a single responsability, their very nature requires that they collaborate to accomplish complex tasks. This collaboration and knowing each other creates dependency.

class Gear

  attr_reader :chainring, :cog, :rim, :tire

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
    @tire = tire
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * Wheel.new(rim, tire).diameter
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

end

puts Gear.new(52, 11, 26, 1.5).gear_inches


# solution #1 dependency injection

class Gear

  attr_reader :chainring, :cog, :rim, :tire

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
    @tire = tire
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end

end

puts Gear.new(52, 11, Wheel.new(26, 1.5)).gear_inches


# solution #2 isolate instances

class Gear

  attr_reader :chainring, :cog, :rim, :tire

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
    @tire = tire
  end

  def gear_inches
    ratio * wheel.diameter
  end

  def wheel
    @wheel ||= Wheel.new(rim, tire)
  end

end

puts Gear.new(52, 11, 26, 1.5).gear_inches



# solution #3 change direction dependency


class Gear

  attr_reader :chainring, :cog

  def initialize(chainring, cog)
    @chainring = chainring
    @cog = cog

  end

  def gear_inches(diameter)
    ratio * wheel.diameter
  end

  def ratio
    chainring / cog.to_f
  end

end


class Wheel
  attr_reader :rim, :tire, :gear

  def initialize(rim:, tire:, chainring:, cog:)
    @rim = rim
    @tire = tire
    @gear = Gear.new(chainring: chainring, cog: cog)
  end

  def diameter
    rim * (tire * 2)
  end

  def gear_inches
    gear.gear_inches(diameter)
  end
end


puts Wheel.new(
  rim:       26,
  tire:      1.5,
  chainring: 51,
  cog:       11).gear_inches



