require 'rails_helper'

RSpec.describe MissionRequestRejection do
  include ActiveJob::TestHelper

  it "respinge la richiesta con il motivo e invia la mail di avviso" do
    requester = create(:user, email: "richiedente@example.com")
    mission_request = create(:mission_request, user: requester, request_approved: nil)

    expect {
      perform_enqueued_jobs do
        described_class.call(mission_request: mission_request, rejection_motivation: "Dati incompleti")
      end
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

    mission_request.reload
    expect(mission_request).to be_rejected
    expect(mission_request.rejection_motivation).to eq("Dati incompleti")
  end

  it "non salva né invia la mail se il motivo è vuoto" do
    mission_request = create(:mission_request, request_approved: nil)

    expect {
      perform_enqueued_jobs do
        described_class.call(mission_request: mission_request, rejection_motivation: "")
      end
    }.not_to change { ActionMailer::Base.deliveries.count }

    expect(mission_request.reload.request_approved).to be_nil
  end

  it "restituisce il mission_request con gli errori se il motivo è vuoto" do
    mission_request = create(:mission_request, request_approved: nil)

    result = described_class.call(mission_request: mission_request, rejection_motivation: "")

    expect(result.errors).to be_present
  end
end
