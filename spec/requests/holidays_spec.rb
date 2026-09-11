require 'rails_helper'

RSpec.describe "Holidays", type: :request do
  include ActiveJob::TestHelper

  let(:org) { { region: "FVG", province: "UD", institute: "CGIL Udine" } }
  let!(:user) { create(:user, **org) }
  let!(:other_user) { create(:user) }
  let!(:holiday) { create(:holiday, :approved, user: user) }
  let!(:other_holiday) { create(:holiday, :approved, user: other_user) }

  before { sign_in user }

  describe "GET /holidays" do
    it "mostra nel calendario solo le proprie ferie approvate" do
      waiting = create(:holiday, user: user, reason: "Richiesta ancora in attesa")

      get holidays_path

      expect(response.body).to include("simple-calendar")
      expect(response.body).to include(user.short_name)
      expect(response.body).to include(holiday.reason)
      expect(response.body).not_to include(other_holiday.reason)
      expect(response.body).not_to include(waiting.reason)
    end

    it "mostra il mese richiesto con start_date" do
      next_month = Date.current.next_month.beginning_of_month + 14.days
      create(:holiday, :approved, user: user, start_date: next_month, end_date: next_month + 1.day, reason: "Ponte di mezza estate")

      get holidays_path
      expect(response.body).not_to include("Ponte di mezza estate")

      get holidays_path(start_date: next_month)
      expect(response.body).to include("Ponte di mezza estate")
    end
  end

  describe "GET /holidays/requests" do
    it "elenca le proprie richieste in attesa e respinte, non le approvate" do
      waiting = create(:holiday, user: user, reason: "Settimana in montagna")
      rejected = create(:holiday, :rejected, user: user, reason: "Crociera")
      create(:holiday, user: other_user, reason: "Richiesta di un altro")

      get requests_holidays_path

      expect(response.body).to include(waiting.reason)
      expect(response.body).to include(rejected.reason)
      expect(response.body).to include(rejected.rejection_motivation)
      expect(response.body).not_to include(holiday.reason)
      expect(response.body).not_to include("Richiesta di un altro")
    end
  end

  describe "GET /holidays/:id" do
    it "consente di vedere le proprie ferie" do
      get holiday_path(holiday)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Approvata")
    end

    it "impedisce di vedere le ferie di un altro utente" do
      get holiday_path(other_holiday)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /holidays" do
    let(:start) { Date.current + 40.days }
    let(:params) { { holiday: { start_date: start, end_date: start + 4.days, reason: "Montagna" } } }

    it "registra già approvate le ferie di un utente senza flag e torna al mese" do
      post holidays_path, params: params

      expect(user.holidays.order(:id).last).to be_request_approved
      expect(user.holidays.order(:id).last).not_to be_requested
      expect(response).to redirect_to(holidays_path(start_date: start))
    end

    context "quando l'utente deve richiedere le ferie" do
      let!(:director) { create(:user, :manager, **org, email: "direttore@example.com") }

      before { user.update!(holiday_requesting_user: true) }

      it "crea una richiesta in attesa e avvisa i direttori della sede" do
        perform_enqueued_jobs { post holidays_path, params: params }

        expect(user.holidays.order(:id).last).to be_pending
        expect(user.holidays.order(:id).last).to be_requested
        expect(response).to redirect_to(requests_holidays_path)
        expect(ActionMailer::Base.deliveries.map(&:to)).to eq([ [ "direttore@example.com" ] ])
      end

      it "ignora un request_approved inviato a mano" do
        post holidays_path, params: { holiday: params[:holiday].merge(request_approved: true) }

        expect(user.holidays.order(:id).last).to be_pending
      end
    end

    it "impedisce a chi non è direttore di inserire ferie per un altro utente" do
      expect {
        post holidays_path, params: { holiday: params[:holiday].merge(user_id: other_user.id) }
      }.not_to change(Holiday, :count)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /holidays/:id" do
    let!(:waiting) { create(:holiday, user: user) }

    it "aggiorna una propria richiesta in attesa" do
      patch holiday_path(waiting), params: { holiday: { reason: "Lago" } }

      expect(waiting.reload.reason).to eq("Lago")
      expect(response).to redirect_to(requests_holidays_path)
    end

    it "rifiuta una data di inizio posteriore alla data di fine" do
      patch holiday_path(waiting), params: { holiday: { end_date: waiting.start_date - 1.day } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Data Inizio non può essere posteriore alla data di fine")
    end

    it "impedisce di modificare ferie approvate" do
      patch holiday_path(holiday), params: { holiday: { reason: "Cambiato" } }

      expect(response).to redirect_to(holiday_path(holiday))
      expect(flash[:alert]).to include("non può essere modificato")
      expect(holiday.reload.reason).not_to eq("Cambiato")
    end

    it "impedisce di modificare ferie respinte" do
      rejected = create(:holiday, :rejected, user: user)

      patch holiday_path(rejected), params: { holiday: { reason: "Cambiato" } }

      expect(flash[:alert]).to include("non può essere modificato")
      expect(rejected.reload.reason).not_to eq("Cambiato")
    end
  end

  describe "ferie inserite direttamente" do
    let!(:direct) { create(:holiday, :direct, user: user, reason: "Ponte di Ognissanti") }

    it "l'utente senza flag le modifica in qualsiasi momento" do
      patch holiday_path(direct), params: { holiday: { reason: "Ponte dei Morti" } }

      expect(direct.reload.reason).to eq("Ponte dei Morti")
      expect(response).to redirect_to(holidays_path(start_date: direct.start_date))
    end

    it "l'utente senza flag le elimina in qualsiasi momento" do
      expect {
        delete holiday_path(direct)
      }.to change(Holiday, :count).by(-1)
    end

    it "chi deve richiedere le ferie non può modificare quelle inserite per lui dal direttore" do
      user.update!(holiday_requesting_user: true)

      patch holiday_path(direct), params: { holiday: { reason: "Cambiato" } }

      expect(flash[:alert]).to eq("Non sei autorizzato a eseguire questa azione.")
      expect(direct.reload.reason).to eq("Ponte di Ognissanti")
    end
  end

  describe "GET /holidays/:id/edit" do
    it "per ferie approvate mostra l'avviso invece del form" do
      get edit_holiday_path(holiday)

      expect(response.body).to include("non può essere modificato")
      expect(response.body).not_to include("holiday_start_date")
    end
  end

  describe "GET /holidays/:id/confirm_destroy" do
    it "mostra la pagina di conferma senza eliminare il record" do
      waiting = create(:holiday, user: user)

      expect {
        get confirm_destroy_holiday_path(waiting)
      }.not_to change(Holiday, :count)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Elimina Definitivamente")
    end
  end

  describe "DELETE /holidays/:id" do
    it "annulla una propria richiesta in attesa e avvisa i direttori via email" do
      create(:user, :manager, **org, email: "direttore@example.com")
      user.update!(holiday_requesting_user: true)
      waiting = create(:holiday, user: user, reason: "Richiesta sbagliata")

      expect {
        perform_enqueued_jobs { delete holiday_path(waiting) }
      }.to change(Holiday, :count).by(-1)

      expect(ActionMailer::Base.deliveries.last.to).to eq([ "direttore@example.com" ])
      expect(ActionMailer::Base.deliveries.last.subject).to include("annullata")
      expect(response).to redirect_to(requests_holidays_path)
      expect(flash[:notice]).to include("il direttore è stato avvisato")
    end

    it "la pagina di conferma avvisa che partirà la mail di annullamento" do
      waiting = create(:holiday, user: user)

      get confirm_destroy_holiday_path(waiting)

      expect(response.body).to include("riceverà una email di annullamento")
    end

    it "elimina una propria richiesta in attesa" do
      waiting = create(:holiday, user: user)

      expect {
        delete holiday_path(waiting)
      }.to change(Holiday, :count).by(-1)
    end

    it "impedisce di eliminare ferie approvate" do
      expect {
        delete holiday_path(holiday)
      }.not_to change(Holiday, :count)

      expect(flash[:alert]).to include("non può essere eliminato")
    end

    it "impedisce di eliminare le ferie di un altro utente" do
      expect {
        delete holiday_path(other_holiday)
      }.not_to change(Holiday, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
