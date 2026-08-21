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

    it "richiede un trasporto" do
      expect(build(:mission_request, transport: nil)).not_to be_valid
    end

    it "richiede il motivo del rigetto se la richiesta è respinta" do
      mission_request = build(:mission_request, request_approved: false, rejection_motivation: nil)
      expect(mission_request).not_to be_valid
    end

    it "è valido se respinta con un motivo" do
      mission_request = build(:mission_request, request_approved: false, rejection_motivation: "Dati incompleti")
      expect(mission_request).to be_valid
    end
  end

  describe "relazioni" do
    it "appartiene a un utente" do
      expect(build(:mission_request, user: nil)).not_to be_valid
    end

    it "il veicolo è opzionale" do
      expect(build(:mission_request, vehicle: nil)).to be_valid
    end
  end

  describe "scopes" do
    it ".pending include solo le richieste non ancora decise" do
      pending_request = create(:mission_request, request_approved: nil)
      create(:mission_request, request_approved: true)
      expect(MissionRequest.pending).to contain_exactly(pending_request)
    end

    it ".approved include solo le richieste approvate" do
      approved_request = create(:mission_request, request_approved: true)
      create(:mission_request, request_approved: nil)
      expect(MissionRequest.approved).to contain_exactly(approved_request)
    end

    it ".rejected include solo le richieste respinte" do
      rejected_request = create(:mission_request, request_approved: false, rejection_motivation: "Dati incompleti")
      create(:mission_request, request_approved: nil)
      expect(MissionRequest.rejected).to contain_exactly(rejected_request)
    end
  end

  describe "#pending? / #rejected? / #locked?" do
    it "#pending? è vero quando request_approved è nil" do
      expect(build(:mission_request, request_approved: nil)).to be_pending
    end

    it "#rejected? è vero quando request_approved è false" do
      mission_request = build(:mission_request, request_approved: false, rejection_motivation: "Dati incompleti")
      expect(mission_request).to be_rejected
    end

    it "#locked? è falso quando la richiesta è in attesa" do
      expect(build(:mission_request, request_approved: nil)).not_to be_locked
    end

    it "#locked? è vero quando la richiesta è approvata" do
      expect(build(:mission_request, request_approved: true)).to be_locked
    end

    it "#locked? è vero quando la richiesta è respinta" do
      mission_request = build(:mission_request, request_approved: false, rejection_motivation: "Dati incompleti")
      expect(mission_request).to be_locked
    end

    it "#decision_label restituisce Approvata o Respinta" do
      expect(build(:mission_request, request_approved: true).decision_label).to eq("Approvata")
      expect(build(:mission_request, request_approved: false, rejection_motivation: "x").decision_label).to eq("Respinta")
    end
  end

  describe "#candidate_validators" do
    it "trova i manager con la stessa region/province/institute del richiedente" do
      requester = create(:user, region: "FVG", province: "UD", institute: "CGIL Udine")
      matching_manager = create(:user, :manager, region: "FVG", province: "UD", institute: "CGIL Udine")
      create(:user, :manager, region: "FVG", province: "TS", institute: "CGIL Udine")
      mission_request = build(:mission_request, user: requester)

      expect(mission_request.candidate_validators).to contain_exactly(matching_manager)
    end

    it "non trova nessun validatore se il richiedente non ha region/province/institute valorizzati" do
      requester = create(:user, region: nil, province: nil, institute: nil)
      create(:user, :manager, region: nil, province: nil, institute: nil)
      mission_request = build(:mission_request, user: requester)

      expect(mission_request.candidate_validators).to be_empty
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
