require 'rails_helper'

RSpec.describe "Validator::MissionRequests", type: :request do
  include ActiveJob::TestHelper

  let!(:requester) { create(:user, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let!(:matching_manager) { create(:user, :manager, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let!(:other_manager) { create(:user, :manager, region: "FVG", province: "TS", institute: "CGIL Udine") }
  let!(:pending_request) { create(:mission_request, user: requester, request_approved: nil, request_date: Date.current) }

  describe "GET /validator/mission_requests" do
    it "mostra al validatore competente le richieste da approvare" do
      sign_in matching_manager

      get validator_mission_requests_path

      expect(response.body).to include(requester.first_name)
    end

    it "non mostra le richieste a un manager non competente" do
      sign_in other_manager

      get validator_mission_requests_path

      expect(response.body).not_to include(requester.first_name)
    end

    it "nega l'accesso a un utente non manager" do
      sign_in requester

      get validator_mission_requests_path

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "PATCH /validator/mission_requests/:id/approve" do
    it "approva la richiesta e crea il rimborso spese" do
      sign_in matching_manager

      expect {
        perform_enqueued_jobs { patch approve_validator_mission_request_path(pending_request) }
      }.to change { Reimbursement.count }.by(1)

      expect(pending_request.reload).to be_request_approved
    end

    it "nega l'approvazione a un manager non competente" do
      sign_in other_manager

      patch approve_validator_mission_request_path(pending_request)

      expect(response).to have_http_status(:redirect)
      expect(pending_request.reload.request_approved).to be_nil
    end
  end

  describe "PATCH /validator/mission_requests/:id/reject" do
    it "respinge la richiesta con il motivo indicato" do
      sign_in matching_manager

      patch reject_validator_mission_request_path(pending_request), params: { rejection_motivation: "Dati incompleti" }

      pending_request.reload
      expect(pending_request).to be_rejected
      expect(pending_request.rejection_motivation).to eq("Dati incompleti")
    end
  end

  describe "GET /validator/mission_requests/approved" do
    it "mostra le richieste già approvate" do
      approved_request = create(:mission_request, user: requester, request_approved: true)
      sign_in matching_manager

      get approved_validator_mission_requests_path

      expect(response.body).to include(approved_request.user.first_name)
    end
  end
end
