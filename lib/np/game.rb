require 'hashie/mash'
require 'json'
require 'np/carrier'
require 'np/player'
require 'np/star'

module NP
  class Game
    attr_reader :player_id, :players, :stars, :carriers, :fleet_speed, :production_rate

    def initialize(data)
      @player_id = data.player_uid
      @players = data.players.map { |k, v| [k.to_i, new_player(v)] }.to_h
      @stars = data.stars.map { |k, v| [k.to_i, new_star(v)] }.to_h
      @carriers = data.fleets.map { |k, v| [k.to_i, new_carrier(v)] }.to_h
      @fleet_speed = data.fleet_speed
      @production_rate = data.production_rate.to_f
    end

    def player
      @players[@player_id]
    end

    def inspect
      "#<Game>"
    end

    protected

    def new_carrier(data)
      Carrier.new(self, data)
    end

    def new_player(data)
      Player.new(self, data)
    end

    def new_star(data)
      Star.new(self, data)
    end
  end
end
