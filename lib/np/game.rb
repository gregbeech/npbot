require 'hashie/mash'
require 'json'
require 'np/carrier'
require 'np/player'
require 'np/star'

module NP
  class Game
    attr_reader :player_id, :players, :stars, :carriers, :fleet_speed

    def self.load(source)
      universe = Hashie::Mash.new(JSON.load(source))
      Game.new(universe.report)
    end

    def initialize(data)
      @player_id = data.player_uid
      @players = data.players.map { |k, v| [k.to_i, Player.new(self, v)] }.to_h
      @stars = data.stars.map { |k, v| [k.to_i, Star.new(self, v)] }.to_h
      @carriers = data.fleets.map { |k, v| [k.to_i, Carrier.new(self, v)] }.to_h
      @fleet_speed = data.fleet_speed
    end

    def player
      @players[@player_id]
    end

    def inspect
      "#<Game>"
    end
  end
end
