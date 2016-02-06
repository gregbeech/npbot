require 'np/combat_calculator'

describe NP::CombatCalculator do
  describe '::calculate' do
    context 'same level; defender wins' do
      subject { described_class.calculate(defender_level: 6, defender_ships: 91, attacker_level: 6, attacker_ships: 107) }

      its(:defender_ships) { should eq 1 }
      its(:attacker_ships) { should eq 0 }
    end

    context 'same level; attacker wins' do
      subject { described_class.calculate(defender_level: 6, defender_ships: 91, attacker_level: 6, attacker_ships: 113) }

      its(:defender_ships) { should eq 0 }
      its(:attacker_ships) { should eq 1 }
    end

    context 'lower level defender; defender wins' do
      subject { described_class.calculate(defender_level: 4, defender_ships: 127, attacker_level: 6, attacker_ships: 107) }

      its(:defender_ships) { should eq 1 }
      its(:attacker_ships) { should eq 0 }
    end

    context 'lower level defender; attacker wins' do
      subject { described_class.calculate(defender_level: 4, defender_ships: 126, attacker_level: 6, attacker_ships: 107) }

      its(:defender_ships) { should eq 0 }
      its(:attacker_ships) { should eq 2 }
    end

    context 'higher level defender; defender wins' do
      subject { described_class.calculate(defender_level: 9, defender_ships: 63, attacker_level: 6, attacker_ships: 110) }

      its(:defender_ships) { should eq 3 }
      its(:attacker_ships) { should eq 0 }
    end

    context 'higher level defender; attacker wins' do
      subject { described_class.calculate(defender_level: 9, defender_ships: 63, attacker_level: 6, attacker_ships: 111) }

      its(:defender_ships) { should eq 0 }
      its(:attacker_ships) { should eq 1 }
    end
  end
end
