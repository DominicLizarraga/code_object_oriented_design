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
