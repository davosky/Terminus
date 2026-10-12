require 'rails_helper'

RSpec.describe Path, type: :model do
  subject(:path) { build(:path) }

  it { is_expected.to be_valid }

  %i[name lenght position user].each do |attribute|
    context "quando #{attribute} è assente" do
      before { path.public_send("#{attribute}=", nil) }

      it { is_expected.not_to be_valid }
    end
  end

  [ 0, -1, 1_000_000 ].each do |lenght|
    context "quando lenght è #{lenght}" do
      before { path.lenght = lenght }

      it { is_expected.not_to be_valid }
    end
  end

  [ -0.01, 1_000_000 ].each do |cost|
    context "quando highway_cost è #{cost}" do
      before { path.highway_cost = cost }

      it { is_expected.not_to be_valid }
    end
  end

  context "quando highway_cost è vuoto" do
    before { path.highway_cost = "" }

    it "vale zero" do
      expect(path).to be_valid
      expect(path.highway_cost).to eq(0)
    end
  end

  [ 0, -1, 1.5 ].each do |position|
    context "quando position è #{position}" do
      before { path.position = position }

      it { is_expected.not_to be_valid }
    end
  end

  context "quando viene salvato" do
    it "è collegato all'utente tramite user_code" do
      user = create(:user)
      expect(create(:path, user: user).user_code).to eq(user.reload.user_code)
    end
  end

  describe ".ordered" do
    it "ordina per posizione" do
      user = create(:user)
      second = create(:path, user: user, position: 2)
      first = create(:path, user: user, position: 1)
      expect(user.paths.ordered).to eq([ first, second ])
    end
  end
end
