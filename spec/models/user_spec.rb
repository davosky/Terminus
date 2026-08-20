require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validazioni" do
    it "è valido con attributi validi" do
      expect(build(:user)).to be_valid
    end

    it "richiede uno username" do
      expect(build(:user, username: nil)).not_to be_valid
    end

    it "richiede uno username univoco" do
      create(:user, username: "mario")
      expect(build(:user, username: "mario")).not_to be_valid
    end

    it "considera lo username univoco senza distinzione tra maiuscole e minuscole" do
      create(:user, username: "mario")
      expect(build(:user, username: "MARIO")).not_to be_valid
    end

    it "richiede una password di almeno 8 caratteri" do
      expect(build(:user, password: "short1A", password_confirmation: "short1A")).not_to be_valid
    end
  end

  describe "autenticazione" do
    it "autentica con lo username, non con l'email" do
      user = create(:user, username: "mario", password: "pAssword1234567")
      expect(user.valid_password?("pAssword1234567")).to be(true)
    end

    it "non richiede l'email" do
      expect(build(:user, username: "mario")).to be_valid
    end
  end

  describe "richiesta missione" do
    it "non richiede la missione di default" do
      expect(build(:user).mission_requesting_user).to be(false)
    end

    it "può essere contraddistinto come utente che richiede la missione" do
      expect(build(:user, mission_requesting_user: true).mission_requesting_user).to be(true)
    end
  end
end
