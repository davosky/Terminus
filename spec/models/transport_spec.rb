require 'rails_helper'

RSpec.describe Transport, type: :model do
  describe "validazioni" do
    it "è valido con attributi validi" do
      expect(build(:transport)).to be_valid
    end

    it "richiede un nome" do
      expect(build(:transport, name: nil)).not_to be_valid
    end
  end

  describe "relazioni" do
    it "appartiene a un utente" do
      expect(build(:transport, user: nil)).not_to be_valid
    end
  end

  describe "#protected_record?" do
    it "è true per \"Veicolo Aziendale\"" do
      expect(build(:transport, name: "Veicolo Aziendale")).to be_protected_record
    end

    it "è true per \"Veicolo Privato\"" do
      expect(build(:transport, name: "Veicolo Privato")).to be_protected_record
    end

    it "è false per un nome qualsiasi" do
      expect(build(:transport, name: "Bicicletta")).not_to be_protected_record
    end
  end
end
