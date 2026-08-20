require 'rails_helper'

RSpec.describe Reimbursement, type: :model do
  describe "validazioni" do
    it "è valido con i modelli memorizzati" do
      expect(build(:reimbursement)).to be_valid
    end

    it "è valido con i soli campi liberi" do
      expect(build(:reimbursement, :free_fields)).to be_valid
    end

    it "richiede un nome" do
      expect(build(:reimbursement, name: nil)).not_to be_valid
    end

    it "richiede un nome univoco" do
      create(:reimbursement, name: "RB-TT-FVG-FVG-202608180925-0001")
      expect(build(:reimbursement, name: "RB-TT-FVG-FVG-202608180925-0001")).not_to be_valid
    end

    it "richiede una data di partenza" do
      expect(build(:reimbursement, departure_date: nil)).not_to be_valid
    end

    it "richiede una data di ritorno" do
      expect(build(:reimbursement, return_date: nil)).not_to be_valid
    end

    it "richiede una data di richiesta" do
      expect(build(:reimbursement, request_date: nil)).not_to be_valid
    end

    it "richiede una data di rimborso" do
      expect(build(:reimbursement, reimbursement_date: nil)).not_to be_valid
    end

    it "non è valido se mancano sia i modelli memorizzati che i campi liberi" do
      reimbursement = build(:reimbursement, reason: nil, place: nil, structure: nil, path: nil)
      expect(reimbursement).not_to be_valid
    end

    it "non è valido se i campi liberi sono incompleti" do
      reimbursement = build(:reimbursement, :free_fields, path_fr: nil, reason: nil, place: nil, structure: nil, path: nil)
      expect(reimbursement).not_to be_valid
    end
  end

  describe "relazioni" do
    it "appartiene a un utente" do
      expect(build(:reimbursement, user: nil)).not_to be_valid
    end

    it "richiede un trasporto" do
      expect(build(:reimbursement, transport: nil)).not_to be_valid
    end

    it "non richiede un veicolo" do
      expect(build(:reimbursement, vehicle: nil)).to be_valid
    end
  end

  describe "#display_reason" do
    it "usa il motivo memorizzato se presente" do
      reason = create(:reason, name: "Formazione")
      expect(build(:reimbursement, reason: reason).display_reason).to eq("Formazione")
    end

    it "usa il campo libero se il motivo non è memorizzato" do
      reimbursement = build(:reimbursement, :free_fields, reason_fr: "Corso")
      expect(reimbursement.display_reason).to eq("Corso")
    end
  end
end
