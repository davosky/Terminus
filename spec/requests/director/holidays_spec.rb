require 'rails_helper'

RSpec.describe "Director::Holidays", type: :request do
  include ActiveJob::TestHelper

  let(:org) { { region: "FVG", province: "UD", institute: "CGIL Udine" } }
  let!(:director) { create(:user, :manager, **org) }
  let!(:employee) { create(:user, :holiday_requesting, **org, email: "dipendente@example.com") }
  let!(:outsider) { create(:user, **org, province: "TS") }
  let!(:pending_request) { create(:holiday, user: employee, reason: "Settimana bianca") }

  def badge_color(body, title)
    Nokogiri::HTML(body).at_css("a.badge[title='#{title}']")["class"][/text-bg-\w+/]
  end

  describe "GET /holidays (calendario)" do
    before do
      create(:holiday, :approved, user: director, reason: "Ferie del direttore")
      create(:holiday, :approved, user: employee, reason: "Ferie del dipendente")
      create(:holiday, :approved, user: outsider, reason: "Ferie di Trieste")
    end

    it "mostra al direttore le proprie ferie e quelle approvate dei dipendenti, ognuno con un colore" do
      sign_in director

      get holidays_path

      expect(response.body).to include("Ferie del direttore", "Ferie del dipendente")
      expect(response.body).not_to include("Ferie di Trieste")
      expect(response.body).not_to include("Settimana bianca")
      expect(badge_color(response.body, "Ferie del direttore")).not_to eq(badge_color(response.body, "Ferie del dipendente"))
    end

    it "mostra le ferie dei dipendenti a un admin che è anche manager" do
      sign_in create(:user, :admin, manager: true, **org)

      get holidays_path

      expect(response.body).to include("Ferie del dipendente")
    end

    it "mostra a un admin non manager solo le proprie ferie" do
      sign_in create(:user, :admin, **org)

      get holidays_path

      expect(response.body).not_to include("Ferie del dipendente")
    end
  end

  describe "POST /holidays dal direttore" do
    let(:start) { Date.current + 30.days }

    before { sign_in director }

    it "propone nel form la select con i soli dipendenti della sede" do
      get new_holiday_path

      expect(response.body).to include(employee.full_name)
      expect(response.body).not_to include(outsider.full_name)
    end

    it "registra già approvate le ferie inserite per un dipendente" do
      post holidays_path, params: { holiday: { start_date: start, end_date: start + 2.days, user_id: employee.id } }

      expect(employee.holidays.order(:id).last).to be_request_approved
    end

    it "non può inserire ferie per un utente di un'altra sede" do
      expect {
        post holidays_path, params: { holiday: { start_date: start, end_date: start, user_id: outsider.id } }
      }.not_to change(Holiday, :count)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /director/holidays" do
    it "elenca le richieste da approvare dei dipendenti della sede" do
      create(:holiday, user: outsider, reason: "Richiesta di Trieste")
      sign_in director

      get director_holidays_path

      expect(response.body).to include("Settimana bianca")
      expect(response.body).not_to include("Richiesta di Trieste")
    end

    it "nega l'accesso a chi non è manager" do
      sign_in employee

      get director_holidays_path

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /holidays/:id di un dipendente" do
    it "mostra al direttore il dettaglio con Approva e Respingi" do
      sign_in director

      get holiday_path(pending_request)

      expect(response.body).to include(approve_director_holiday_path(pending_request))
      expect(response.body).to include(reject_director_holiday_path(pending_request))
      expect(response.body).not_to include(edit_holiday_path(pending_request))
    end
  end

  describe "PATCH /director/holidays/:id/approve" do
    it "approva, avvisa il dipendente e mette le ferie nel calendario" do
      sign_in director

      perform_enqueued_jobs { patch approve_director_holiday_path(pending_request) }

      expect(pending_request.reload).to be_request_approved
      expect(ActionMailer::Base.deliveries.last.to).to eq([ "dipendente@example.com" ])
    end

    it "nega l'approvazione a un manager di un'altra sede" do
      sign_in create(:user, :manager, **org, province: "TS")

      patch approve_director_holiday_path(pending_request)

      expect(response).to have_http_status(:not_found)
      expect(pending_request.reload).to be_pending
    end
  end

  describe "PATCH /director/holidays/:id/reject" do
    before { sign_in director }

    it "respinge la richiesta con il motivo indicato" do
      patch reject_director_holiday_path(pending_request), params: { rejection_motivation: "Chiusura di bilancio" }

      expect(pending_request.reload).to be_rejected
      expect(pending_request.rejection_motivation).to eq("Chiusura di bilancio")
    end

    it "non respinge senza motivo" do
      patch reject_director_holiday_path(pending_request), params: { rejection_motivation: "" }

      expect(flash[:alert]).to be_present
      expect(pending_request.reload).to be_pending
    end
  end

  describe "aggiornamento in tempo reale" do
    let!(:other_director) { create(:user, :manager, **org, province: "TS") }

    it "iscrive allo stream il calendario e la lista del direttore, non il calendario del dipendente" do
      sign_in director
      get holidays_path
      expect(response.body).to include("turbo-cable-stream-source")
      get director_holidays_path
      expect(response.body).to include("turbo-cable-stream-source")

      sign_in employee
      get holidays_path
      expect(response.body).not_to include("turbo-cable-stream-source")
    end

    it "una nuova richiesta aggiorna le pagine dei soli direttori della sede" do
      sign_in employee

      assert_turbo_stream_broadcasts [ director, :holidays ], count: 1 do
        post holidays_path, params: { holiday: { start_date: Date.current + 10.days, end_date: Date.current + 11.days } }
      end
      assert_no_turbo_stream_broadcasts [ other_director, :holidays ]
    end

    it "approvare, modificare ed eliminare aggiornano le pagine del direttore" do
      direct = create(:holiday, :direct, user: employee)
      sign_in director

      assert_turbo_stream_broadcasts [ director, :holidays ], count: 3 do
        patch approve_director_holiday_path(pending_request)
        patch holiday_path(direct), params: { holiday: { reason: "Spostate" } }
        delete holiday_path(direct)
      end
    end
  end

  describe "ferie inserite dal direttore per un dipendente" do
    let!(:direct) { create(:holiday, :direct, user: employee, reason: "Inserite dal direttore") }

    before { sign_in director }

    it "il direttore le modifica in qualsiasi momento" do
      patch holiday_path(direct), params: { holiday: { reason: "Spostate dal direttore" } }

      expect(direct.reload.reason).to eq("Spostate dal direttore")
    end

    it "il direttore le elimina in qualsiasi momento" do
      expect {
        delete holiday_path(direct)
      }.to change(Holiday, :count).by(-1)
    end

    it "il direttore non può invece modificare una richiesta del dipendente" do
      patch holiday_path(pending_request), params: { holiday: { reason: "Cambiato" } }

      expect(flash[:alert]).to eq("Non sei autorizzato a eseguire questa azione.")
      expect(pending_request.reload.reason).to eq("Settimana bianca")
    end
  end

  describe "ferie approvate" do
    before { pending_request.update!(request_approved: true) }

    it "non possono più essere modificate dal dipendente" do
      sign_in employee

      patch holiday_path(pending_request), params: { holiday: { reason: "Cambiato" } }

      expect(pending_request.reload.reason).to eq("Settimana bianca")
    end

    it "non possono essere modificate né eliminate dal direttore" do
      sign_in director

      patch holiday_path(pending_request), params: { holiday: { reason: "Cambiato" } }
      delete holiday_path(pending_request)

      expect(flash[:alert]).to eq("Non sei autorizzato a eseguire questa azione.")
      expect(pending_request.reload.reason).to eq("Settimana bianca")
    end
  end
end
