require 'np/game'

describe NP::Game do
  describe '::load' do
    subject do
      File.open(File.join(__dir__, 'data', 'game.json')) do |f|
        described_class.load(f)
      end
    end

    it { expect(subject.players.size).to eq 24 }
    it { expect(subject.stars.size).to eq 340 }
    it { expect(subject.carriers.size).to eq 16 }
  end
end
