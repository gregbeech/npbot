module NP
  class Carrier
    attr_reader :id, :name, :player_id, :star_id, :position, :last_position,
                :ships, :orders

    def initialize(data)
      @id = data.uid
      @name = data.n
      @player_id = data.puid
      @star_id = data.ouid
      @position = [data.x.to_f, data.y.to_f]
      @last_position = [data.lx.to_f, data.ly.to_f]
      @ships = data.st
      @orders = data.o.map { |o| make_orders(*o) }
      @looping = data.l.to_i != 0
      @warp_speed = data.w.to_i != 0
    end

    def looping?
      @looping
    end

    def warp_speed?
      @warp_speed
    end

    private

    def make_orders(delay, star_id, action, ships)
      Orders.new(star_id, Orders::ACTIONS[action], delay: delay, ships: ships)
    end

    class Orders
      attr_reader :star_id, :action, :delay, :ships

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

      def initialize(star_id, action, delay: 0, ships: 0)
        @star_id = star_id
        @action = action
        @delay = delay
        @ships = ships
      end

      def ==(other)
        %i[star_id action delay ships].all? do |attr_name|
          public_send(attr_name) == other.public_send(attr_name)
        end
      end
      alias_method :eql?, :==
    end
  end
end
