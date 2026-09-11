require 'rails_helper'

RSpec.describe "HolidayValidations", type: :request do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  let!(:employee) { create(:user, :holiday_requesting, email: "dipendente@example.com") }
  let!(:holiday) { create(:holiday, user: employee) }
  # Lo stesso token che genera HolidayMailer#validation_request.
  let(:token) { holiday.signed_id(expires_in: 30.days, purpose: "holiday_validation") }

  describe "GET /validazione_ferie/:token/approva" do
    it "mostra la pagina di conferma senza approvare nulla" do
      get approve_form_holiday_validation_path(token: token)

      expect(response).to have_http_status(:ok)
      expect(holiday.reload).to be_pending
    end

    it "avvisa se la richiesta è già stata elaborata" do
      holiday.update!(request_approved: true)

      get approve_form_holiday_validation_path(token: token)

      expect(response.body).to include("già stata elaborata")
    end

    it "mostra un messaggio se il token non è valido" do
      get approve_form_holiday_validation_path(token: "invalid")

      expect(response.body).to include("non è valido")
    end
  end

  describe "POST /validazione_ferie/:token/approva" do
    it "approva senza bisogno di login e avvisa il dipendente" do
      perform_enqueued_jobs { post approve_holiday_validation_path(token: token) }

      expect(holiday.reload).to be_request_approved
      expect(ActionMailer::Base.deliveries.last.to).to eq([ "dipendente@example.com" ])
    end

    it "non approva con un token scaduto" do
      emitted = token

      travel_to 31.days.from_now do
        post approve_holiday_validation_path(token: emitted)

        expect(response.body).to include("non è valido")
        expect(holiday.reload).to be_pending
      end
    end
  end

  describe "GET /validazione_ferie/:token/respingi" do
    it "mostra il form per inserire il motivo" do
      get reject_form_holiday_validation_path(token: token)

      expect(response.body).to include("rejection_motivation")
    end
  end

  describe "POST /validazione_ferie/:token/respingi" do
    it "respinge la richiesta con il motivo indicato" do
      post reject_holiday_validation_path(token: token), params: { rejection_motivation: "Chiusura di bilancio" }

      expect(holiday.reload).to be_rejected
      expect(holiday.rejection_motivation).to eq("Chiusura di bilancio")
    end

    it "richiede un motivo non vuoto" do
      post reject_holiday_validation_path(token: token), params: { rejection_motivation: "" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(holiday.reload).to be_pending
    end

    it "non respinge una richiesta già approvata" do
      holiday.update!(request_approved: true)

      post reject_holiday_validation_path(token: token), params: { rejection_motivation: "Tardi" }

      expect(response.body).to include("già stata elaborata")
      expect(holiday.reload).to be_request_approved
    end
  end
end
