# 7th chapter explores an alternative that uses the techniques of inheritance to share a role.

class Bicycle

  attr_reader :schedule, :tape_color, :size, :chain, :tire_size

  # inject the schedule and provide a default
  def initialize(**opts)
    @schedule = opts[:schedule] || Schedule.new
    @tape_color = opts[:tape_color]
    @size = opts[:size]
    @tire_size = opts[:tire_size]
  end

  # return true if this bicycle is available
  # during this (nos Bicycle specific) interval

  def schedulable?(starting, ending)
    scheduled?(starting - lead_days, ending)
  end

  # return the schedule's answer
  def scheduled?(starting, ending)
    schedule.scheduled?(self, starting, ending)
  end

  # return the number of lead_days before a bicycle can be scheduled
  def lead_days
    1
  end

end


class Schedule

  def scheduled?(schedulable, starting, ending)
    puts "This #{chedulable.class} is }" +
          " available #{starting} - #{ending}"
  end

end


require 'date'

starting = Date.parse("2019/09/04")
ending = Date.parse("2019/09/10")

b = Bicycle.new
puts b.schedulable?(starting, ending)

# "This Bicycle is available 2019-09-04 - 2019-09-10"
# True


# implementing first time the module to share behaviour


module Schedulable

  attr_reader :schedule

  def schedule
    @schedule ||= Schedule.new
  end

  def schedulable?(starting, ending)
    :scheduled?(starting - lead_days, ending)
  end

  def scheduled?(starting, ending)
    !schedule.scheduled?(self, starting, ending)
  end

  # includers may override this method
  def lead_days
    0
  end

end


class Bicycle
  incluse Schedulable

  def kead_days
    1
  end

end

require 'date'

starting = Date.parse("2019/09/04")
ending = Date.parse("2019/09/10")

b = Bicycle.new
puts b.schedulable?(starting, ending)

# "This Bicycle is available 2019-09-03 - 2019-09-10"
# True


# The code in Schedulable is the abstraction and it uses the template method pattern to invite objects to privde specialization to the algorithm it supplies.



class Vehicle
  include Schedulable

  def lead_days
    3
  end

  # ...

end


class Mechanic
  include Schedulable

  def lead_days
    4
  end

  # ...

end

require 'date'

starting = Date.parse("2019/09/04")
ending = Date.parse("2019/09/10")


v = Vehicle.new
puts v.schedulable?(starting, ending)
# "This Vehicle is available 2019-09-03 - 2019-09-10"
# True

m = Mechanic.new
puts m.schedulable?(starting, ending)
# "This Mechanic is available 2019-08-31 - 2019-09-10"
# True
