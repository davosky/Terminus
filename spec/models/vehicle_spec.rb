require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  subject(:vehicle) { build(:vehicle) }

  it { is_expected.to be_valid }

  %i[producer name licence_plate power cost_per_km position user].each do |attribute|
    context "quando #{attribute} è assente" do
      before { vehicle.public_send("#{attribute}=", nil) }

      it { is_expected.not_to be_valid }
    end
  end

  context "quando power non è tra le alimentazioni previste" do
    before { vehicle.power = "Vapore" }

    it { is_expected.not_to be_valid }
  end

  [ -0.01, 1_000_000 ].each do |cost|
    context "quando cost_per_km è #{cost}" do
      before { vehicle.cost_per_km = cost }

      it { is_expected.not_to be_valid }
    end
  end

  [ 0, -1, 1.5 ].each do |position|
    context "quando position è #{position}" do
      before { vehicle.position = position }

      it { is_expected.not_to be_valid }
    end
  end

  context "quando viene salvato" do
    it "è collegato all'utente tramite user_code" do
      user = create(:user)
      expect(create(:vehicle, user: user).user_code).to eq(user.reload.user_code)
    end
  end

  describe ".ordered" do
    it "ordina per posizione" do
      user = create(:user)
      second = create(:vehicle, user: user, position: 2)
      first = create(:vehicle, user: user, position: 1)
      expect(user.vehicles.ordered).to eq([ first, second ])
    end
  end

  describe "#full_name" do
    it { expect(build(:vehicle, producer: "Fiat", name: "Panda").full_name).to eq("Fiat Panda") }
  end
end
