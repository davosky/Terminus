require 'rails_helper'

RSpec.describe Holiday, type: :model do
  describe "validazioni" do
    it "è valido con attributi validi" do
      expect(build(:holiday)).to be_valid
    end

    it "richiede la data di inizio" do
      expect(build(:holiday, start_date: nil)).not_to be_valid
    end

    it "richiede la data di fine" do
      expect(build(:holiday, end_date: nil)).not_to be_valid
    end

    it "non accetta una data di inizio posteriore alla data di fine" do
      holiday = build(:holiday, start_date: Date.current, end_date: Date.current - 1.day)

      expect(holiday).not_to be_valid
      expect(holiday.errors[:start_date]).to include("non può essere posteriore alla data di fine")
    end

    it "accetta ferie di un solo giorno" do
      expect(build(:holiday, start_date: Date.current, end_date: Date.current)).to be_valid
    end

    it "non richiede il motivo" do
      expect(build(:holiday, reason: nil)).to be_valid
    end

    it "richiede il motivo del rifiuto quando è respinta" do
      expect(build(:holiday, request_approved: false, rejection_motivation: nil)).not_to be_valid
    end
  end

  describe "relazioni" do
    it "appartiene a un utente" do
      expect(build(:holiday, user: nil)).not_to be_valid
    end
  end

  describe "stato" do
    it "è in attesa e modificabile finché nessuno decide" do
      holiday = build(:holiday)

      expect(holiday).to be_pending
      expect(holiday).not_to be_locked
    end

    it "è bloccata una volta approvata" do
      holiday = build(:holiday, :approved)

      expect(holiday).to be_locked
      expect(holiday.decision_label).to eq("Approvata")
    end

    it "è bloccata una volta respinta" do
      holiday = build(:holiday, :rejected)

      expect(holiday).to be_rejected
      expect(holiday).to be_locked
      expect(holiday.decision_label).to eq("Respinta")
    end

    it "non si blocca mai se inserita direttamente" do
      holiday = build(:holiday, :direct)

      expect(holiday).not_to be_pending
      expect(holiday).not_to be_locked
    end

    it "separa in attesa, approvate e respinte con gli scope" do
      pending_holiday = create(:holiday)
      approved = create(:holiday, :approved)
      rejected = create(:holiday, :rejected)

      expect(Holiday.pending).to contain_exactly(pending_holiday)
      expect(Holiday.approved).to contain_exactly(approved)
      expect(Holiday.rejected).to contain_exactly(rejected)
    end
  end

  describe "#candidate_validators" do
    it "restituisce i direttori della sede del richiedente" do
      org = { region: "FVG", province: "UD", institute: "CGIL Udine" }
      director = create(:user, :manager, **org)
      create(:user, :manager, **org, province: "TS")
      holiday = create(:holiday, user: create(:user, **org))

      expect(holiday.candidate_validators).to contain_exactly(director)
    end
  end

  describe "#submitted_by" do
    let(:org) { { region: "FVG", province: "UD", institute: "CGIL Udine" } }
    let(:employee) { create(:user, :holiday_requesting, **org) }

    it "rende una richiesta in attesa le ferie che un dipendente con il flag inserisce per sé" do
      holiday = build(:holiday, user: employee, requested: false).submitted_by(employee)

      expect(holiday).to be_requested
      expect(holiday).to be_pending
    end

    it "approva subito le ferie inserite dal direttore per il dipendente" do
      holiday = build(:holiday, user: employee).submitted_by(create(:user, :manager, **org))

      expect(holiday).not_to be_requested
      expect(holiday).to be_request_approved
    end

    it "approva subito le ferie di chi non deve richiederle" do
      unflagged = create(:user)
      holiday = build(:holiday, user: unflagged).submitted_by(unflagged)

      expect(holiday).not_to be_requested
      expect(holiday).to be_request_approved
    end
  end

  describe "#display_reason" do
    it "restituisce il motivo, o 'Ferie' se manca" do
      expect(build(:holiday, reason: "Ponte").display_reason).to eq("Ponte")
      expect(build(:holiday, reason: "").display_reason).to eq("Ferie")
    end
  end
end
