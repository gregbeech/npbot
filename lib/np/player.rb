module NP
  class Player
    attr_reader :id, :name, :stats, :researching

    def initialize(data)
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

    %i[scanning hyperspace_range terraforming experimentation weapons banking manufacturing].each do |attr_name|
      define_method attr_name do
        @tech[attr_name]
      end
    end

    private

    def tech_name(name)
      name = name&.to_sym
      case name
      when :propulsion then :hyperspace_range
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
      attr_reader :level, :research

      def initialize(data)
        @level = data.level
        @research = data.research # points towards next level
        # TODO: What are value, sv, bv, brr?
      end
    end
  end
end
