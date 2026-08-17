require 'rails_helper'

RSpec.describe Place, type: :model do
  describe "validazioni" do
    it "è valido con attributi validi" do
      expect(build(:place)).to be_valid
    end

    it "richiede un nome" do
      expect(build(:place, name: nil)).not_to be_valid
    end
  end

  describe "relazioni" do
    it "appartiene a un utente" do
      expect(build(:place, user: nil)).not_to be_valid
    end
  end
end
