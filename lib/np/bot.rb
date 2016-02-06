module NP
  class Bot
    attr_reader :game

    def initialize(game)
      @game = game
    end

    def star_reached!(star, carrier)
      puts "--------> #{star.name} (#{star.player&.name || 'free'}) reached by #{carrier.name} (#{carrier.player.name})"
    end
  end
end
