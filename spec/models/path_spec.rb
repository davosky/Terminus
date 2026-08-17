require 'rails_helper'

RSpec.describe Path, type: :model do
  describe "validazioni" do
    it "è valido con attributi validi" do
      expect(build(:path)).to be_valid
    end

    it "richiede un nome" do
      expect(build(:path, name: nil)).not_to be_valid
    end

    it "richiede una lunghezza" do
      expect(build(:path, lenght: nil)).not_to be_valid
    end

    it "non accetta una lunghezza negativa" do
      expect(build(:path, lenght: -1)).not_to be_valid
    end

    it "richiede un costo autostrada" do
      expect(build(:path, highway_cost: nil)).not_to be_valid
    end

    it "non accetta un costo autostrada negativo" do
      expect(build(:path, highway_cost: -0.10)).not_to be_valid
    end
  end

  describe "relazioni" do
    it "appartiene a un utente" do
      expect(build(:path, user: nil)).not_to be_valid
    end
  end
end
