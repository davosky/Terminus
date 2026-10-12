require 'rails_helper'

RSpec.describe Structure, type: :model do
  subject(:structure) { build(:structure) }

  it { is_expected.to be_valid }

  %i[name position user].each do |attribute|
    context "quando #{attribute} è assente" do
      before { structure.public_send("#{attribute}=", nil) }

      it { is_expected.not_to be_valid }
    end
  end

  [ 0, -1, 1.5 ].each do |position|
    context "quando position è #{position}" do
      before { structure.position = position }

      it { is_expected.not_to be_valid }
    end
  end

  context "quando viene salvato" do
    it "è collegato all'utente tramite user_code" do
      user = create(:user)
      expect(create(:structure, user: user).user_code).to eq(user.reload.user_code)
    end
  end

  describe ".ordered" do
    it "ordina per posizione" do
      user = create(:user)
      second = create(:structure, user: user, position: 2)
      first = create(:structure, user: user, position: 1)
      expect(user.structures.ordered).to eq([ first, second ])
    end
  end
end
