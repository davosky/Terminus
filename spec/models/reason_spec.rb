require 'rails_helper'

RSpec.describe Reason, type: :model do
  describe "validazioni" do
    it "è valido con attributi validi" do
      expect(build(:reason)).to be_valid
    end

    it "richiede un nome" do
      expect(build(:reason, name: nil)).not_to be_valid
    end
  end

  describe "relazioni" do
    it "appartiene a un utente" do
      expect(build(:reason, user: nil)).not_to be_valid
    end
  end
end
