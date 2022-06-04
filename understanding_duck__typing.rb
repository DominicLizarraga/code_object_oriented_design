# 5th chapter covers the benefits and the characteristics of duck typing and how to tackle


# The purpose of object oriented design is to reduce the cost of change.

# Duck typing are more defined by its behavior than its class

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
