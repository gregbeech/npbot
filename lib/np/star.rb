require 'np/locatable'

module NP
  class Star
    include Locatable

    attr_reader :game, :id, :name, :player_id, :position, :economy, :industry,
                :science, :natural_resources, :resources, :ships

    def initialize(game, data)
      @game = game
      @id = data.uid
      @name = data.n
      @player_id = data.puid
      @visible = data.v.to_i != 0
      @position = [data.x.to_f, data.y.to_f]
      @economy = data.e
      @industry = data.i
      @science = data.s
      @natural_resources = data.nr
      @resources = data.r
      @warp_gate = data.ga.to_i != 0
      @ships = data.st
      # TODO: What is "c"?
    end

    # Whether the details of this star are visible to the current player.
    def visible?
      @visible
    end

    # The player who currently owns the star; may be nil if not owned.
    def player
      @game.players[@player_id]
    end

    # Whether this star has a warp gate. Will be nil if invisible.
    def warp_gate?
      return nil unless visible?
      @warp_gate
    end

    # The number of new ships the star produces every tick. Will be nil if invisible.
    def new_ships
      return nil unless visible?
      industry * (player.manufacturing.value + 5) / game.production_rate
    end

    # Carriers that are currently on the star. Will be empty if invisible.
    def carriers
      return [] unless visible?
      @game.carriers.values.select { |c| distance(c) < 0.0001 } # TODO: Is this sufficient
    end

    # Stars that are reachable from this star. Will be empty if invisible.
    def reachable_stars
      return [] unless visible?
      range = player.range.value
      # TODO
    end

    def travel_time(star)
      speed = game.fleet_speed
      speed *= 3 if warp_gate? && star.warp_gate?
      (distance(star) / speed).ceil
    end

    def inspect
      "#<Star '#{name}' @ #{position[0]},#{position[1]}>"
    end
  end
end
