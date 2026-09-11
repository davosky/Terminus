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

  describe "amministrazione (payroll)" do
    it "non è di amministrazione di default" do
      expect(build(:user).payroll).to be(false)
    end

    it "può essere contraddistinto come utente di amministrazione" do
      expect(build(:user, payroll: true).payroll).to be(true)
    end
  end

  describe "#short_name" do
    it "abbrevia il nome all'iniziale e tiene il cognome per intero" do
      expect(build(:user, first_name: "Mario", last_name: "Rossi").short_name).to eq("M. Rossi")
    end

    it "senza nome mostra solo il cognome" do
      expect(build(:user, first_name: nil, last_name: "Rossi").short_name).to eq("Rossi")
    end

    it "senza nome né cognome ripiega sullo username" do
      expect(build(:user, username: "mrossi", first_name: "", last_name: nil).short_name).to eq("mrossi")
    end
  end

  describe "ferie" do
    let(:org) { { region: "FVG", province: "UD", institute: "CGIL Udine" } }

    it "non richiede le ferie di default" do
      expect(build(:user).holiday_requesting_user).to be(false)
    end

    it "#colleagues restituisce chi condivide regione, provincia e istituto, sé compreso" do
      me = create(:user, **org)
      colleague = create(:user, **org)
      create(:user, **org, province: "TS")

      expect(me.colleagues).to contain_exactly(me, colleague)
    end

    it "#colleagues è vuoto se manca uno dei tre campi" do
      create(:user, **org)

      expect(create(:user, **org, institute: nil).colleagues).to be_empty
    end

    it "#directors restituisce solo i manager tra i colleghi" do
      me = create(:user, **org)
      director = create(:user, :manager, **org)

      expect(me.directors).to contain_exactly(director)
    end

    it "#holiday_team: sé stesso per un dipendente, sé e i colleghi per un direttore" do
      employee = create(:user, **org)
      director = create(:user, :manager, **org)

      expect(employee.holiday_team).to contain_exactly(employee)
      expect(director.holiday_team).to contain_exactly(director, employee)
    end

    it "#requires_holiday_approval? vale solo per un dipendente con il flag" do
      expect(build(:user, :holiday_requesting).requires_holiday_approval?).to be(true)
      expect(build(:user).requires_holiday_approval?).to be(false)
      expect(build(:user, :manager, :holiday_requesting).requires_holiday_approval?).to be(false)
    end
  end
end
