require 'rails_helper'

RSpec.describe HolidayMailer, type: :mailer do
  let(:employee) { create(:user, first_name: "Angela", last_name: "Tortorella", email: "dipendente@example.com") }
  let(:holiday) { create(:holiday, user: employee) }

  describe "#validation_request" do
    it "invia la mail al direttore con i link firmati" do
      director = create(:user, :manager, email: "direttore@example.com")

      mail = described_class.validation_request(holiday, director).deliver_now

      expect(mail.to).to eq([ "direttore@example.com" ])
      expect(mail.subject).to include("Angela Tortorella")
      expect(mail.text_part.decoded).to include("validazione_ferie", "approva", "respingi")
    end

    it "non invia nulla se il direttore non ha una email" do
      director = create(:user, :manager, email: nil)

      expect {
        described_class.validation_request(holiday, director).deliver_now
      }.not_to change { ActionMailer::Base.deliveries.count }
    end
  end

  describe "#approved" do
    it "avvisa il dipendente dell'approvazione" do
      mail = described_class.approved(holiday).deliver_now

      expect(mail.to).to eq([ "dipendente@example.com" ])
      expect(mail.text_part.decoded).to include("approvata")
    end
  end

  describe "#rejected" do
    it "avvisa il dipendente del rifiuto con il motivo" do
      holiday.update!(request_approved: false, rejection_motivation: "Chiusura di bilancio")

      mail = described_class.rejected(holiday).deliver_now

      expect(mail.to).to eq([ "dipendente@example.com" ])
      expect(mail.text_part.decoded).to include("Chiusura di bilancio")
    end
  end

  describe "#cancelled" do
    let(:details) { { requester: "Angela Tortorella", start_date: Date.new(2026, 10, 5), end_date: Date.new(2026, 10, 9), reason: "Crociera" } }

    it "avvisa il direttore che la richiesta è stata annullata" do
      director = create(:user, :manager, email: "direttore@example.com")

      mail = described_class.cancelled(director, details).deliver_now

      expect(mail.to).to eq([ "direttore@example.com" ])
      expect(mail.subject).to eq("Richiesta ferie annullata - Angela Tortorella")
      expect(mail.text_part.decoded).to include("5 ottobre 2026", "9 ottobre 2026", "Crociera")
    end

    it "non invia nulla se il direttore non ha una email" do
      expect {
        described_class.cancelled(create(:user, :manager, email: nil), details).deliver_now
      }.not_to change { ActionMailer::Base.deliveries.count }
    end
  end
end
