require 'np/game'
require 'np/sim/carrier'
require 'np/sim/player'
require 'np/sim/star'

module NP
  module Sim
    class Game < NP::Game
      def self.load(source)
        universe = Hashie::Mash.new(JSON.load(source))
        new(universe.report)
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
end