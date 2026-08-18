require 'rails_helper'

RSpec.describe MissionRequest, type: :model do
  describe "validazioni" do
    it "è valido con i modelli memorizzati" do
      expect(build(:mission_request)).to be_valid
    end

    it "è valido con i soli campi liberi" do
      expect(build(:mission_request, :free_fields)).to be_valid
    end

    it "richiede un nome" do
      expect(build(:mission_request, name: nil)).not_to be_valid
    end

    it "richiede un nome univoco" do
      create(:mission_request, name: "MR-TT-FVG-FVG-202608180925-0001")
      expect(build(:mission_request, name: "MR-TT-FVG-FVG-202608180925-0001")).not_to be_valid
    end

    it "richiede una data di partenza" do
      expect(build(:mission_request, departure_date: nil)).not_to be_valid
    end

    it "richiede una data di ritorno" do
      expect(build(:mission_request, return_date: nil)).not_to be_valid
    end

    it "richiede una data di richiesta" do
      expect(build(:mission_request, request_date: nil)).not_to be_valid
    end

    it "non è valido se mancano sia i modelli memorizzati che i campi liberi" do
      mission_request = build(:mission_request, reason: nil, place: nil, structure: nil, path: nil)
      expect(mission_request).not_to be_valid
    end

    it "non è valido se i campi liberi sono incompleti" do
      mission_request = build(:mission_request, :free_fields, path_fr: nil, reason: nil, place: nil, structure: nil, path: nil)
      expect(mission_request).not_to be_valid
    end
  end

  describe "relazioni" do
    it "appartiene a un utente" do
      expect(build(:mission_request, user: nil)).not_to be_valid
    end
  end

  describe "#display_reason" do
    it "usa il motivo memorizzato se presente" do
      reason = create(:reason, name: "Formazione")
      expect(build(:mission_request, reason: reason).display_reason).to eq("Formazione")
    end

    it "usa il campo libero se il motivo non è memorizzato" do
      mission_request = build(:mission_request, :free_fields, reason_fr: "Corso")
      expect(mission_request.display_reason).to eq("Corso")
    end
  end
end
