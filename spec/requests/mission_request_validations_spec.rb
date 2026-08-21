require 'rails_helper'

RSpec.describe "MissionRequestValidations", type: :request do
  include ActiveJob::TestHelper

  let!(:requester) { create(:user, email: "richiedente@example.com") }
  let!(:mission_request) { create(:mission_request, user: requester, request_approved: nil) }
  let(:token) { mission_request.signed_id(purpose: "mission_request_validation") }

  describe "GET /validazione_missione/:token/approva" do
    it "mostra la pagina di conferma senza approvare nulla" do
      expect {
        get approve_form_mission_request_validation_path(token: token)
      }.not_to change { Reimbursement.count }

      expect(response).to have_http_status(:ok)
      expect(mission_request.reload.request_approved).to be_nil
    end

    it "mostra un messaggio se il token non è valido" do
      get approve_form_mission_request_validation_path(token: "invalid")

      expect(response.body).to include("non è valido")
    end
  end

  describe "POST /validazione_missione/:token/approva" do
    it "approva la richiesta senza bisogno di login" do
      expect {
        perform_enqueued_jobs { post approve_mission_request_validation_path(token: token) }
      }.to change { Reimbursement.count }.by(1)

      expect(response).to have_http_status(:ok)
      expect(mission_request.reload).to be_request_approved
    end

    it "non ripete l'azione se la richiesta è già stata elaborata" do
      mission_request.update!(request_approved: true)

      expect {
        post approve_mission_request_validation_path(token: token)
      }.not_to change { Reimbursement.count }

      expect(response.body).to include("già stata elaborata")
    end

    it "mostra un messaggio se il token non è valido" do
      post approve_mission_request_validation_path(token: "invalid")

      expect(response.body).to include("non è valido")
    end
  end

  describe "GET /validazione_missione/:token/respingi" do
    it "mostra il form per inserire il motivo" do
      get reject_form_mission_request_validation_path(token: token)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("rejection_motivation")
    end
  end

  describe "POST /validazione_missione/:token/respingi" do
    it "respinge la richiesta con il motivo indicato" do
      post reject_mission_request_validation_path(token: token), params: { rejection_motivation: "Dati incompleti" }

      mission_request.reload
      expect(mission_request).to be_rejected
      expect(mission_request.rejection_motivation).to eq("Dati incompleti")
    end

    it "richiede un motivo non vuoto" do
      post reject_mission_request_validation_path(token: token), params: { rejection_motivation: "" }

      expect(mission_request.reload.request_approved).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
