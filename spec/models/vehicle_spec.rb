require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe "validazioni" do
    it "è valido con attributi validi" do
      expect(build(:vehicle)).to be_valid
    end

    it "richiede un nome" do
      expect(build(:vehicle, name: nil)).not_to be_valid
    end

    it "richiede un produttore" do
      expect(build(:vehicle, producer: nil)).not_to be_valid
    end

    it "richiede una targa" do
      expect(build(:vehicle, licence_plate: nil)).not_to be_valid
    end

    it "richiede un costo al km" do
      expect(build(:vehicle, cost_per_km: nil)).not_to be_valid
    end

    it "non accetta un costo al km negativo" do
      expect(build(:vehicle, cost_per_km: -0.10)).not_to be_valid
    end
  end

  describe "relazioni" do
    it "appartiene a un utente" do
      expect(build(:vehicle, user: nil)).not_to be_valid
    end
  end
end
