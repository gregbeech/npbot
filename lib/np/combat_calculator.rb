module NP
  module CombatCalculator
    def self.calculate(defender_level:, defender_ships:, attacker_level:, attacker_ships:)
      defender_level += 1 # defender bonus

      defender_rounds = rounds(attacker_ships, defender_level)
      attacker_rounds = rounds(defender_ships, attacker_level)

      if defender_rounds <= attacker_rounds
        defender_ships -= attacker_level * (defender_rounds - 1) # defender strikes first
        attacker_ships = 0
      else
        attacker_ships -= defender_level * attacker_rounds
        defender_ships = 0
      end

      Hashie::Mash.new(defender_ships: defender_ships, attacker_ships: attacker_ships)
    end

    private

    def self.rounds(ships, damage)
      whole, partial = ships.divmod(damage)
      partial == 0 ? whole : whole + 1
    end
  end
end
