require 'np/carrier'

describe NP::Carrier do
  describe '#initialize' do
    let(:data) do
      OpenStruct.new(
        uid: 56,
        l: 1,
        o: [
          [0, 192, 1, 0],
          [0, 144, 5, 3],
          [3, 191, 2, 0]
        ],
        n: 'Alrami I',
        puid: 4,
        w: 0,
        y: '1.01240775',
        x: '0.53530646',
        st: 32,
        lx: '0.49469581',
        ly: '1.00308646')
    end

    subject { NP::Carrier.new(data) }

    its(:id) { should eq 56 }
    its(:looping?) { should eq true }
    its(:orders) { should eq [
      NP::Carrier::Orders.new(192, :collect_all, delay: 0, ships: 0),
      NP::Carrier::Orders.new(144, :collect_all_but, delay: 0, ships: 3),
      NP::Carrier::Orders.new(191, :drop_all, delay: 3, ships: 0),
    ] }
    its(:name) { should eq 'Alrami I' }
    its(:player_id) { should eq 4 }
    its(:warp_speed?) { should eq false }
    its(:position) { should eq [0.53530646, 1.01240775] }
    its(:ships) { should eq 32 }
    its(:last_position) { should eq [0.49469581, 1.00308646] }
  end
end