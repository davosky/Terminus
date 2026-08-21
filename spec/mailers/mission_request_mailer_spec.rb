require 'rails_helper'

RSpec.describe MissionRequestMailer, type: :mailer do
  describe "#validation_request" do
    it "invia la mail al validatore con i link firmati" do
      mission_request = create(:mission_request)
      validator = create(:user, :manager, email: "validatore@example.com")

      mail = described_class.validation_request(mission_request, validator).deliver_now

      expect(mail.to).to eq([ "validatore@example.com" ])
      expect(mail.subject).to include(mission_request.user.first_name)
      expect(mail.text_part.decoded).to include("approva")
      expect(mail.text_part.decoded).to include("respingi")
    end

    it "non invia nulla se il validatore non ha una email" do
      mission_request = create(:mission_request)
      validator = create(:user, :manager, email: nil)

      expect {
        described_class.validation_request(mission_request, validator).deliver_now
      }.not_to change { ActionMailer::Base.deliveries.count }
    end
  end

  describe "#approved" do
    it "invia la mail di conferma al richiedente" do
      requester = create(:user, email: "richiedente@example.com")
      mission_request = create(:mission_request, user: requester)
      reimbursement = create(:reimbursement, user: requester)

      mail = described_class.approved(mission_request, reimbursement).deliver_now

      expect(mail.to).to eq([ mission_request.user.email ])
      expect(mail.text_part.decoded).to include(reimbursement.name)
    end
  end

  describe "#rejected" do
    it "invia la mail con il motivo del rigetto al richiedente" do
      requester = create(:user, email: "richiedente@example.com")
      mission_request = create(:mission_request, user: requester, request_approved: false, rejection_motivation: "Dati incompleti")

      mail = described_class.rejected(mission_request).deliver_now

      expect(mail.to).to eq([ mission_request.user.email ])
      expect(mail.text_part.decoded).to include("Dati incompleti")
    end
  end
end
