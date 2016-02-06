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

    def visible?
      @visible
    end

    def warp_gate?
      @warp_gate
    end

    def player
      @game.players[@player_id]
    end

    def reachable_stars
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
