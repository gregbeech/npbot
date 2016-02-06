module NP
  class Player
    attr_reader :game, :id, :name, :stats, :researching

    def initialize(game, data)
      @game = game
      @id = data.uid
      @name = data.alias
      @ai = data.ai.to_i != 0
      @stats = Stats.new(data)
      @tech = data.tech.map { |k, v| [tech_name(k), TechLevel.new(v)] }.to_h
      @researching = tech_name(data.researching)
    end

    def ai?
      @ai
    end

    %i[scanning range terraforming experimentation weapons banking manufacturing].each do |attr_name|
      define_method attr_name do
        @tech[attr_name]
      end
    end

    def stars
      @game.stars.values.select { |s| s.player_id == @id }
    end

    def carriers
      @game.carriers.values.select { |c| c.player_id == @id }
    end

    def inspect
      "#<Player '#{name}'>"
    end

    private

    def tech_name(name)
      name = name&.to_sym
      case name
      when :propulsion then :range
      when :research then :experimentation
      else name
      end
    end

    class Stats
      attr_reader :stars, :strength, :economy, :industry, :science, :carriers

      def initialize(data)
        @stars = data.total_stars
        @strength = data.total_strength
        @economy = data.total_economy
        @industry = data.total_industry
        @science = data.total_science
        @carriers = data.total_fleets
      end
    end

    class TechLevel
      attr_reader :level, :value, :starting_value, :incremental_value, :research, :incremental_research

      def initialize(data)
        @level = data.level
        @value = data.value
        @starting_value = data.sv
        @incremental_value = data.bv
        @research = data.research # points towards next level
        @incremental_research = data.brr
      end

      def value_at(level)
        @starting_value + (@incremental_value * level)
      end
    end
  end
end
