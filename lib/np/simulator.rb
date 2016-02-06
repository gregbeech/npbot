module NP
  class Simulator
    attr_reader :bot, :game

    def initialize(bot)
      @bot = bot
      @game = bot.game
    end

    def tick!
      @game.carriers.values.each { |c| move_carrier(c) }
    end

    def print_game_state
      puts "carriers:"
      @game.carriers.values.each { |c| puts "  #{c.name}: #{c.last_position} => #{c.position}" }
    end

    private

    def move_carrier(carrier)
      carrier.last_position = carrier.position
      return if carrier.orders.empty?

      origin_star = carrier.origin_star
      target_star = carrier.orders.first.star

      # update the warp speed if we can check whether both stars have warp gates; for enemy ships
      # where a started game was loaded we may not know the origin star so just keep the setting
      carrier.warp_speed = origin_star.warp_gate? && target_star.warp_gate? if origin_star

      distance = carrier.distance(target_star)
      speed = carrier.speed
      if distance > speed
        # not going to reach the target
        x1, y1 = carrier.position
        x2, y2 = target_star.position
        angle = Math.atan2(y2 - y1, x2 - x1)
        carrier.position = [x1 + Math.cos(angle) * speed, y1 + Math.sin(angle) * speed]
      else
        # reached the target
        carrier.position = target_star.position
        carrier.origin_star = target_star
        if carrier.looping?
          carrier.orders.rotate!
        else
          carrier.orders.shift
        end
        @bot.star_reached!(target_star, carrier)
      end
    end
  end
end
