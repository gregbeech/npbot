require 'np/locatable'

module NP
  class Carrier
    include Locatable

    attr_reader :game, :id, :player_id, :name, :origin_star_id, :position, :last_position, :ships, :orders

    def initialize(game, data)
      @game = game
      @id = data.uid
      @name = data.n
      @player_id = data.puid
      @origin_star_id = data.ouid
      @position = [data.x.to_f, data.y.to_f]
      @last_position = [data.lx.to_f, data.ly.to_f]
      @ships = data.st
      @orders = data.o.map { |o| make_orders(*o) }
      @looping = data.l.to_i != 0
      @warp_speed = data.w.to_i != 0
    end

    def player
      @game.players[@player_id]
    end

    def origin_star
      @game.stars[@origin_star_id]
    end

    def warp_speed?
      @warp_speed
    end

    def looping?
      @looping
    end

    def speed
      speed = game.fleet_speed
      speed *= 3 if warp_speed?
      speed
    end

    def travel_time(star)
      (distance(star) / speed).ceil
    end

    def inspect
      "#<Carrier '#{name}' (#{player.name}) @ #{position[0]},#{position[1]}>"
    end

    private

    def make_orders(delay, star_id, action, ships)
      Orders.new(@game.stars[star_id], Orders::ACTIONS[action], delay: delay, ships: ships)
    end

    class Orders
      attr_reader :star, :action, :delay, :ships

      ACTIONS = {
        0 => :do_nothing,
        1 => :collect_all,
        2 => :drop_all,
        3 => :collect,
        4 => :drop,
        5 => :collect_all_but,
        6 => :drop_all_but,
        7 => :garrison
      }

      def initialize(star, action, delay: 0, ships: 0)
        @star = star
        @action = action
        @delay = delay
        @ships = ships
      end

      def ==(other)
        return false unless star&.id == other.star&.id
        %i[action delay ships].all? do |attr_name|
          public_send(attr_name) == other.public_send(attr_name)
        end
      end
      alias_method :eql?, :==
    end
  end
end
