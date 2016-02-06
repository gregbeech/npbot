require 'np/game'
require 'np/player'

describe NP::Player do
  let(:game) { instance_double(NP::Game) }

  describe '#initialize' do
    let(:data) do
      Hashie::Mash.new(
        researching: 'propulsion',
        uid: 4,
        ai: 0,
        huid: 12,
        total_fleets: 8,
        ready: 0,
        karma_to_give: 16,
        war: {
          '0' => 3,
          '1' => 3,
          '2' => 3,
          '3' => 3,
          '4' => 3,
          '5' => 3,
          '6' => 3,
          '7' => 3,
          '8' => 3,
          '9' => 3,
          '10' => 3,
          '11' => 3,
          '12' => 3,
          '13' => 3,
          '14' => 3,
          '15' => 3,
          '16' => 3,
          '17' => 3,
          '18' => 3,
          '19' => 3,
          '20' => 3,
          '21' => 3,
          '22' => 3,
          '23' => 3
        },
        total_industry: 27,
        total_stars: 12,
        regard: 0,
        conceded: 0,
        total_science: 12,
        stars_abandoned: 0,
        cash: 74,
        total_strength: 911,
        alias: 'notbobby',
        tech: {
          scanning: {
            level: 3,
            sv: 0.25,
            value: 0.625,
            research: 325,
            bv: 0.125,
            brr: 144
          },
          propulsion: {
            level: 4,
            sv: 0.375,
            value: 0.875,
            research: 0,
            bv: 0.125,
            brr: 144
          },
          terraforming: {
            level: 4,
            sv: 0,
            value: 4,
            research: 8,
            bv: 1,
            brr: 144
          },
          research: {
            level: 4,
            sv: 0,
            value: 480,
            research: 0,
            bv: 120,
            brr: 144
          },
          weapons: {
            level: 5,
            sv: 0,
            value: 5,
            research: 3,
            bv: 1,
            brr: 144
          },
          banking: {
            level: 3,
            sv: 0,
            value: 3,
            research: 0,
            bv: 1,
            brr: 144
          },
          manufacturing: {
            level: 3,
            sv: 0,
            value: 3,
            research: 4,
            bv: 1,
            brr: 144
          }
        },
        avatar: 36,
        researching_next: 'banking',
        total_economy: 25,
        countdown_to_war: {
          '0' => 0,
          '1' => 0,
          '2' => 0,
          '3' => 0,
          '4' => 0,
          '5' => 0,
          '6' => 0,
          '7' => 0,
          '8' => 0,
          '9' => 0,
          '10' => 0,
          '11' => 0,
          '12' => 0,
          '13' => 0,
          '14' => 0,
          '15' => 0,
          '16' => 0,
          '17' => 0,
          '18' => 0,
          '19' => 0,
          '20' => 0,
          '21' => 0,
          '22' => 0,
          '23' => 0
        },
        missed_turns: 0)
    end

    subject { described_class.new(game, data) }

    its(:researching) { should eq :range }
    its(:id) { should eq 4 }
    its(:ai?) { should eq false }
    its(:name) { should eq 'notbobby' }
    # TODO: More
  end
end