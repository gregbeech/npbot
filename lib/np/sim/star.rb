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

        defender = player || carriers.sort_by { |c| c.origin_star&.distance(self) || 1000 }.first.player
        defender_carriers, attacker_carriers = carriers.partition { |c| c.player == defender }

        defender_ships = ships + defender_carriers.map(&:ships).reduce(0, :+)
        attacker_ships = attacker_carriers.map(&:ships).reduce(0, :+)

        result = CombatCalculator.calculate(
          defender_level: defender.weapons.value,
          defender_ships: defender_ships,
          attacker_level: attacker_carriers.map { |c| c.player.weapons.value }.max,
          attacker_ships: attacker_ships)

        puts "========> combat at #{name}: #{defender.name} -vs- #{attacker_carriers.map { |c| c.player.name }.join(', ')}"
        puts "========>   result: defender_ships = #{result.defender_ships}, attacker_ships = #{result.attacker_ships}"

        apply_carrier_losses!(defender_carriers, defender_ships - result.defender_ships)
        apply_carrier_losses!(attacker_carriers, attacker_ships - result.attacker_ships)
        destroy_carriers!(carriers.select { |c| c.ships == 0 })
      end

      private

      def shortest_journey(carriers)
        # don't know how far it's come if there's no origin star; assume it's a long way
        carriers.map { |c| c.origin_star&.distance(self) || 1000 }.min
      end

      def apply_carrier_losses!(carriers, lost_ships)
        return unless lost_ships > 0

        # apply losses evenly to all carriers and collect losses that can't be applied
        carrier_loss, extra_losses = lost_ships.divmod(carriers.size)
        carriers.each do |carrier|
          if carrier_loss <= carrier.ships
            carrier.ships -= carrier_loss
          else
            extra_losses += carrier_loss - carrier.ships
            carrier.ships = 0
          end
        end

        # if more extras than surviving ships try again otherwise mop up the losses
        surviving = carriers.select { |c| c.ships > 0 }
        if extra_losses > surviving.size
          apply_carrier_losses!(surviving, extra_losses)
        else
          carriers.take(extra_losses).each { |c| c.ships -= 1 }
        end
      end

      def destroy_carriers!(carriers)
        @game.carriers.reject! { |_, c| carriers.include?(c) }
      end
    end
  end
end
