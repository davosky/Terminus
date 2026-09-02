require 'rails_helper'

RSpec.describe "Director::MissionRequests", type: :request do
  let!(:requester) { create(:user, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let!(:matching_manager) { create(:user, :manager, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let!(:other_manager) { create(:user, :manager, region: "FVG", province: "TS", institute: "CGIL Udine") }
  let!(:pending_request) { create(:mission_request, user: requester, request_approved: nil) }
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
  end
end
