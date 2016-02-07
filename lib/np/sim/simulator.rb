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
        star.settle_dispute!
        # TODO: Ship actions here...
        star.produce_ships!
      end
    end
  end
end
