require 'rails_helper'

RSpec.describe "Director::MissionRequests", type: :request do
  include ActiveJob::TestHelper

  let!(:requester) { create(:user, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let!(:matching_manager) { create(:user, :manager, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let!(:other_manager) { create(:user, :manager, region: "FVG", province: "TS", institute: "CGIL Udine") }
  let!(:pending_request) { create(:mission_request, user: requester, request_approved: nil) }
  let!(:approved_request) { create(:mission_request, user: requester, request_approved: true) }
  let!(:rejected_request) { create(:mission_request, user: requester, request_approved: false, rejection_motivation: "Dati incompleti") }

  describe "GET /director/mission_requests" do
    it "mostra al direttore le richieste dei suoi dipendenti in ogni stato" do
      sign_in matching_manager

      get director_mission_requests_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(requester.first_name)
      expect(response.body).to include(director_mission_request_path(pending_request))
      expect(response.body).to include(director_mission_request_path(rejected_request))
    end

    it "non mostra le richieste a un manager di un'altra sede" do
      sign_in other_manager

      get director_mission_requests_path

      expect(response.body).not_to include(director_mission_request_path(pending_request))
    end

    it "nega l'accesso a un utente non manager" do
      sign_in requester

      get director_mission_requests_path

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /director/mission_requests/approved" do
    it "elenca solo le richieste approvate dei dipendenti del direttore" do
      sign_in matching_manager

      get approved_director_mission_requests_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(director_mission_request_path(approved_request))
      expect(response.body).not_to include(director_mission_request_path(pending_request))
      expect(response.body).not_to include(director_mission_request_path(rejected_request))
    end

    it "nega l'accesso a un utente non manager" do
      sign_in requester

      get approved_director_mission_requests_path

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /director/mission_requests/rejected" do
    it "elenca solo le richieste respinte dei dipendenti del direttore" do
      sign_in matching_manager

      get rejected_director_mission_requests_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(director_mission_request_path(rejected_request))
      expect(response.body).not_to include(director_mission_request_path(approved_request))
      expect(response.body).not_to include(director_mission_request_path(pending_request))
    end
  end

  describe "GET /director/mission_requests/:id" do
    it "consente al direttore competente di vedere il dettaglio" do
      sign_in matching_manager

      get director_mission_request_path(pending_request)

      expect(response).to have_http_status(:ok)
    end

    it "risponde 404 per una richiesta fuori dalla propria sede" do
      sign_in other_manager

      get director_mission_request_path(pending_request)

      expect(response).to have_http_status(:not_found)
    end

    it "mostra i dati della missione ma nessun dato del rimborso spese collegato" do
      create(:reimbursement, user: requester, mission_request: pending_request, generic_cost: 123.45)
      sign_in matching_manager

      get director_mission_request_path(pending_request)

      expect(response.body).to include(pending_request.name)
      expect(response.body).not_to include("123.45")
    end

    it "mostra i pulsanti Approva/Respingi solo per una richiesta in attesa" do
      sign_in matching_manager

      get director_mission_request_path(pending_request)
      expect(response.body).to include(approve_director_mission_request_path(pending_request))

      get director_mission_request_path(approved_request)
      expect(response.body).not_to include(approve_director_mission_request_path(approved_request))
    end
  end

  describe "PATCH /director/mission_requests/:id/approve" do
    it "approva la richiesta e crea il rimborso spese" do
      sign_in matching_manager

      expect {
        perform_enqueued_jobs { patch approve_director_mission_request_path(pending_request) }
      }.to change { Reimbursement.count }.by(1)

      expect(pending_request.reload).to be_request_approved
      expect(response).to redirect_to(director_mission_request_path(pending_request))
    end

    it "nega l'approvazione a un manager di un'altra sede" do
      sign_in other_manager

      patch approve_director_mission_request_path(pending_request)

      expect(response).to have_http_status(:not_found)
      expect(pending_request.reload.request_approved).to be_nil
    end

    it "nega l'approvazione a un utente non manager" do
      sign_in requester

      patch approve_director_mission_request_path(pending_request)

      expect(response).to redirect_to(root_path)
    end

    it "non ri-approva una richiesta già decisa" do
      sign_in matching_manager

      patch approve_director_mission_request_path(approved_request)

      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH /director/mission_requests/:id/reject" do
    it "respinge la richiesta con il motivo indicato" do
      sign_in matching_manager

      patch reject_director_mission_request_path(pending_request), params: { rejection_motivation: "Budget esaurito" }

      pending_request.reload
      expect(pending_request).to be_rejected
      expect(pending_request.rejection_motivation).to eq("Budget esaurito")
      expect(response).to redirect_to(director_mission_request_path(pending_request))
    end

    it "non respinge senza motivo" do
      sign_in matching_manager

      patch reject_director_mission_request_path(pending_request), params: { rejection_motivation: "" }

      expect(pending_request.reload.request_approved).to be_nil
    end
  end
end
