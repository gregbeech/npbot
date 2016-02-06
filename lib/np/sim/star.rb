require 'np/combat_calculator'
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

      def disputed?
        carriers.map(&:player_id).uniq.size > 1
      end

      def settle_dispute!
        return unless disputed?

        puts "========> combat at #{name}"

        defender = player || carriers.sort_by { |c| c.origin_star&.distance(self) || 1000 }.first.player
        defender_level = defender.weapons.value
        defender_ships = ships + carriers.select { |c| c.player == defender }.map(&:ships).reduce(0, :+)

        # TODO: Get attackers and calculate losses



      end

      private

      def shortest_journey(carriers)
        # don't know how far it's come if there's no origin star; assume it's a long way
        carriers.map { |c| c.origin_star&.distance(self) || 1000 }.min
      end
    end
  end
end
