# 5th chapter covers the benefits and the characteristics of duck typing and how to tackle.


# The purpose of object oriented design is to reduce the cost of change.

# Duck typing is more defined by its behavior than its class.

class Trip

  attr_reader :bicycle, :customers, :vehicule

  def prepare(prepares)
    prepares.each { |preparer|
      case preparer
      when Mechanic
        preparer prepare_bicycle(bicycles)
      when TripCordinator
        preparer buy_food(customers)
      when Driver
        preparer gas_up(vehicule)
        preparer fill_water_tank(vehicule)
      end
    }
  end

end

class TripCoordinator

  def buy_food(customers)

  end
end

class Driver

  def preparer gas_up(vehicule)

  end

  def preparer fill_water_tank(vehicule)


  end
end


# ********removing case statements********

class Trip

  attr_reader :bicycle, :customers, :vehicule

  def prepare(prepares)
    prepares.each { |preparer|
      preparer.prepare_trip(self)}
  end
end

class Mechanic
  def prepare_trip(trip)
    trip.bicycles.each { |bicycle|
      prepare_bicycle(bicycle)}
  end
end

class TripCoordinator
  def prepare_trip(trip)
    buy_food(trip.customers)
  end
end

class Driver
  def prepare_trip(trip)
    vehicule = trip.vehicule
    gas_up(vehicule)
    fill_water_tank(vehicule)
  end

end


# how to identify a duck typing with kind_of? and is_a? methods


if preparer.kind_of?(Mechanic)
  preparer.prepare_bicycle(bicycles)
elsif preparer.kind_of?(TripCoordinator)
  preparer.buy_food(customers)
elsif preparer.kind_of?(Driver)
  preparer.gas_up(vehicule)
  preparer.fill_water_tank(vehicule)
end

# also checking if preparer method respons to some others instance methods is a way to verify if this is a candidate to be replaced

if preparer respond_to?(:prepare_bicycle)
  preparer.prepare_bicycle(bicycles)
elsif preparer.respond_to(:buy_food)
  preparer.buy_food(:customers)
elsif preparer.respond_to(:gas_up)
  preparer.gas_up(vehicule)
  preparer.fill_water_tank(vehicule)
end



