require 'np/star'

module NP
  module Sim
    class Star < NP::Star
      def ships
        @ships.to_i # may be a float as they are produced but only whole ones available
      end

      def produce_ships!
        raise 'Unknown industry' if industry.nil?
        @ships += industry * (player.manufacturing.value + 5) / game.production_rate
      end
    end
  end
end
