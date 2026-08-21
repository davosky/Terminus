require 'rails_helper'

RSpec.describe MissionRequestApproval do
  include ActiveJob::TestHelper

  it "approva la richiesta, crea il rimborso e invia la mail di conferma" do
    requester = create(:user, email: "richiedente@example.com")
    mission_request = create(:mission_request, user: requester, request_approved: nil)

    expect {
      perform_enqueued_jobs { described_class.call(mission_request: mission_request) }
    }.to change { Reimbursement.count }.by(1)
      .and change { ActionMailer::Base.deliveries.count }.by(1)

    expect(mission_request.reload).to be_request_approved
  end

  it "restituisce il rimborso creato" do
    mission_request = create(:mission_request, request_approved: nil)

    reimbursement = described_class.call(mission_request: mission_request)

    expect(reimbursement).to be_a(Reimbursement)
    expect(reimbursement).to be_persisted
  end
end
