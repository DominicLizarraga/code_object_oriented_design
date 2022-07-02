# 9th designing Cost_effective Tests


# Refactoring is the process of changing a software system in such a way that it does not alter the external behavior of the code yet improves the internal structure.

class Wheel
  attr_reader :rim, :size
  def initialize(rim, size)
    @rim  = rim
    @size = size
  end

  def diameter
    rim + (tire * 2)
  end

end

class Gear
  attr_reader :changring, :cog, :rim, :tire

  def initialize(changring, cog, rim, tire)
    @changring = changring
    @cog       = cog
    @rim       = rim
    @tire      = tire
  end

  def gear_inches
    ratio * Wheel.new(rim, tire).diameter
  end

  def raio
    changring / cog.to_f
  end

end
