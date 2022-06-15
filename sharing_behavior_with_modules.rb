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




