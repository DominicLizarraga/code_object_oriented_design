# 8th chapter composition allows you to combine small parts to create more complex objets such that the whole becomes more than the sum of its parts.

# Those objets tend to consist of simple, discrete entities that can easily be rearranged into a new combinations.


# Also can be easi to understan, reuser and test.


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

