require 'rails_helper'

RSpec.describe "MissionRequestValidations", type: :request do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  let!(:requester) { create(:user, email: "richiedente@example.com") }
  let!(:mission_request) { create(:mission_request, user: requester, request_approved: nil) }
  # Lo stesso token che genera MissionRequestMailer#validation_request.
  let(:token) { mission_request.signed_id(expires_in: 30.days, purpose: "mission_request_validation") }

  describe "scadenza del link" do
    # Il token va generato prima del salto temporale, altrimenti nascerebbe
    # con la data futura e non scadrebbe mai.
    let!(:emitted_token) { token }

    it "resta valido entro i 30 giorni" do
      travel_to 29.days.from_now do
        get approve_form_mission_request_validation_path(token: emitted_token)

        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include("non è valido")
      end
    end

    it "non è più utilizzabile dopo 30 giorni" do
      travel_to 31.days.from_now do
        get approve_form_mission_request_validation_path(token: emitted_token)

        expect(response.body).to include("non è valido")
      end
    end

    it "non approva nulla con un token scaduto" do
      travel_to 31.days.from_now do
        expect {
          post approve_mission_request_validation_path(token: emitted_token)
        }.not_to change { Reimbursement.count }

        expect(mission_request.reload.request_approved).to be_nil
      end
    end
  end

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

    it "avvisa se la richiesta è già stata elaborata" do
      mission_request.update!(request_approved: true)

      get approve_form_mission_request_validation_path(token: token)

      expect(response.body).to include("già stata elaborata")
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

    it "mostra un messaggio se il token non è valido" do
      get reject_form_mission_request_validation_path(token: "invalid")

      expect(response.body).to include("non è valido")
    end

    it "avvisa se la richiesta è già stata elaborata" do
      mission_request.update!(request_approved: true)

      get reject_form_mission_request_validation_path(token: token)

      expect(response.body).to include("già stata elaborata")
      expect(response.body).not_to include("rejection_motivation")
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

    it "mostra un messaggio se il token non è valido" do
      post reject_mission_request_validation_path(token: "invalid"), params: { rejection_motivation: "Dati incompleti" }

      expect(response.body).to include("non è valido")
      expect(mission_request.reload.request_approved).to be_nil
    end

    it "non respinge una richiesta già approvata" do
      mission_request.update!(request_approved: true)

      post reject_mission_request_validation_path(token: token), params: { rejection_motivation: "Dati incompleti" }

      expect(response.body).to include("già stata elaborata")
      expect(mission_request.reload).to be_request_approved
      expect(mission_request.rejection_motivation).to be_nil
    end
  end
end
