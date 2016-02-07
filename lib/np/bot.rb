module NP
  class Bot
    attr_reader :game

    def initialize(game)
      @game = game
    end

    def star_reached!(star, carrier)
      puts "--------> #{carrier.name} (#{carrier.player.name}) arrived at #{star.name} (#{star.player&.name || 'free'})"
    end
  end
end
