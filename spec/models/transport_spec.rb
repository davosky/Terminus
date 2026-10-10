require 'rails_helper'

RSpec.describe Transport, type: :model do
  subject(:transport) { build(:transport) }

  it { is_expected.to be_valid }

  %i[transport_name transport_position user].each do |attribute|
    context "quando #{attribute} è assente" do
      before { transport.public_send("#{attribute}=", nil) }

      it { is_expected.not_to be_valid }
    end
  end

  [ 0, -1, 1.5 ].each do |position|
    context "quando transport_position è #{position}" do
      before { transport.transport_position = position }

      it { is_expected.not_to be_valid }
    end
  end

  context "quando viene salvato" do
    it "è collegato all'utente tramite user_code" do
      user = create(:user)
      expect(create(:transport, user: user).user_code).to eq(user.reload.user_code)
    end
  end

  describe ".ordered" do
    it "ordina per posizione" do
      user = create(:user)
      second = create(:transport, user: user, transport_position: 2)
      first = create(:transport, user: user, transport_position: 1)
      expect(user.transports.ordered).to eq([ first, second ])
    end
  end
end
