require 'np/carrier'

module NP
  module Sim
    class Carrier < NP::Carrier
      attr_writer :name, :origin_star_id, :position, :last_position, :ships, :orders, :warp_speed

      def origin_star=(star)
        @origin_star_id = star&.id
      end

      def travel_towards!(star)
        x1, y1 = position
        x2, y2 = star.position
        angle = Math.atan2(y2 - y1, x2 - x1)
        self.position = [x1 + Math.cos(angle) * speed, y1 + Math.sin(angle) * speed]
      end
    end
  end
end
