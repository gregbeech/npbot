require 'np/game'
require 'np/star'

describe NP::Star do
  let(:game) { instance_double(NP::Game) }

  describe '#initialize' do
    context 'when not visible' do
      let(:data) do
        Hashie::Mash.new(
          uid: 6,
          n: 'Zosma',
          puid: 20,
          v: '0',
          y: '-1.8980',
          x: '-1.1271')
      end

      subject { described_class.new(game, data) }

      its(:id) { should eq 6 }
      its(:name) { should eq 'Zosma' }
      its(:player_id) { should eq 20 }
      its(:visible?) { should eq false }
      its(:position) { should eq [-1.1271, -1.8980] }
    end

    context 'when visible' do
      let(:data) do
        Hashie::Mash.new(
          c: 0.91666666666666496, # TODO: What is this?
          e: 5,
          uid: 18,
          i: 5,
          s: 2,
          n: 'Acrux',
          puid: 2,
          r: 70,
          ga: 0,
          v: '1',
          y: '0.7001',
          x: '1.8729',
          nr: 50,
          st: 36)
      end

      subject { described_class.new(game, data) }

      its(:economy) { should eq 5 }
      its(:id) { should eq 18 }
      its(:industry) { should eq 5 }
      its(:science) { should eq 2 }
      its(:name) { should eq 'Acrux' }
      its(:player_id) { should eq 2 }
      its(:resources) { should eq 70 }
      its(:warp_gate?) { should eq false }
      its(:visible?) { should eq true }
      its(:position) { should eq [1.8729, 0.7001] }
      its(:natural_resources) { should eq 50 }
      its(:ships) { should eq 36 }
    end
  end
end