require 'rails_helper'

RSpec.describe CreateDefaultTransports do
  let(:user) { create(:user) }

  context "quando l'utente non ha trasporti" do
    before { described_class.call(user) }

    it "crea i due trasporti predefiniti e protetti" do
      expect(user.transports.ordered.pluck(:transport_name, :transport_position, :locked))
        .to eq([ [ "Veicolo Privato", 1, true ], [ "Veicolo Aziendale", 2, true ] ])
    end
  end

  context "quando viene richiamato due volte" do
    before { 2.times { described_class.call(user) } }

    it "non crea duplicati" do
      expect(user.transports.count).to eq(2)
    end
  end
end
