module NP
  class Bot
    attr_reader :game

    def initialize(game)
      @game = game
    end

    def star_reached!(star, carrier)
      puts "--------> #{star.name} reached by #{carrier.name}"
    end
  end
end
