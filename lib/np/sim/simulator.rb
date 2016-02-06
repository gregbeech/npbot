require 'pp'
require 'np/sim/game'

module NP
  module Sim
    class Simulator
      attr_reader :bot, :game

      def initialize(bot)
        @bot = bot
        @game = bot.game
      end

      def tick!
        @game.carriers.values.each { |c| carrier_tick!(c) }
        @game.stars.values.select(&:visible?).each { |s| star_tick!(s) } # visible hack for in-progress games
      end

      def print_game_state
        puts "carriers:"
        @game.carriers.values.sort_by(&:name).each { |c| puts "  #{c.name} (#{c.player.name}): #{c.ships} ships, #{c.last_position} => #{c.position}" }
        puts "stars:"
        # visible hack for in-progress games
        @game.stars.values.sort_by(&:name).select(&:visible?).each { |s| puts "  #{s.name} (#{s.player&.name || 'free'}): #{s.ships} + #{s.carriers.map(&:ships).reduce(0, :+)} ships, #{s.carriers.size} carriers" }
      end

      private

      def carrier_tick!(carrier)
        carrier.last_position = carrier.position
        return if carrier.orders.empty?

        target_star = carrier.orders.first.star

        # update the warp speed if we can check whether both stars have warp gates; for enemy ships
        # where a started game was loaded we may not know the origin star so just keep the setting
        carrier.warp_speed = target_star.warp_gate? && carrier.origin_star.warp_gate? if carrier.origin_star

        ## TODO: If leaving a star need to set origin star; can't set it on arrival as need to check
        ## distance when deciding who goes first in a battle

        if carrier.travel_time(target_star) > 1
          carrier.travel_towards!(target_star)
        else
          # reached the target
          carrier.position = target_star.position
          if carrier.looping?
            carrier.orders.rotate!
          else
            carrier.orders.shift
          end
          @bot.star_reached!(target_star, carrier)
        end
      end

      def star_tick!(star)
        star.produce_ships!

        carriers = star.carriers
        return unless carriers.map { |c| c.player_id }.uniq.size > 1

        puts "========> battle at #{star.name}"

        factions = carriers.group_by(&:player).sort_by do |p, cs|
          [p == star.player ? 0 : 1, cs.map { |c| c.origin_star ? star.distance(c.origin_star) : 1000 }.max]
        end

        # TODO: This code is seriously awful, needs rewriting much better
        while factions.size > 1
          factions.each do |p1, _|
            factions.reject { |p2, _| p1 == p2 }.each do |p2, cs|
              damage = p2.weapons.value
              ## FIXME: divide damage between carriers
              cs.each { |c| c.ships -= damage }
              cs.reject! { |c| c.ships <= 0 }
            end
          end
          factions.reject! { |_, cs| cs.empty? }
          game.carriers.reject! { |_, c| c.ships <= 0 }
        end

      end
    end
  end
end
