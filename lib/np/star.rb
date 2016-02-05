module NP
  class Star
    attr_reader :id, :name, :player_id, :position, :economy, :industry,
                 :science, :natural_resources, :resources, :ships

    def initialize(data)
      @id = data.uid
      @name = data.n
      @player_id = data.puid
      @visible = data.v.to_i != 0
      @position = [data.x.to_f, data.y.to_f]
      @economy = data.e
      @industry = data.i
      @science = data.s
      @natural_resources = data.nr
      @resources = data.r
      @warp_gate = data.ga.to_i != 0
      @ships = data.st
      # TODO: What is "c"?
    end

    def visible?
      @visible
    end

    def warp_gate?
      @warp_gate
    end

    def player
      raise NotImplementedError
    end
  end
end
