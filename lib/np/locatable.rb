module NP
  # includer must implement game, player, position
  module Locatable
    def distance(other)
      x1, y1 = position
      x2, y2 = other.position
      Math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
    end

    def travel_time(other)
      (distance(other) / game.fleet_speed).ceil
    end

    def in_range?(other)
      distance(other) <= player.range.value
    end

    def range_level(other)
      d = distance(other)
      (1..100).find { |level| d <= player.range.value_at(level) }
    end
  end
end
