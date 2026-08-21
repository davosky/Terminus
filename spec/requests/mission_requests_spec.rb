require 'rails_helper'

RSpec.describe "MissionRequests", type: :request do
  include ActiveJob::TestHelper

  let!(:user) { create(:user, region: "FVG", province: "FVG", institute: "CGIL") }
  let!(:other_user) { create(:user) }
  let!(:mission_request) { create(:mission_request, user: user) }
  let!(:other_mission_request) { create(:mission_request, user: other_user) }

  before { sign_in user }

  describe "GET /mission_requests" do
    it "mostra solo le richieste missione dell'utente corrente" do
      get mission_requests_path

      expect(response.body).to include(mission_request_path(mission_request))
      expect(response.body).not_to include(mission_request_path(other_mission_request))
    end

    it "mostra i bottoni modifica ed elimina per una richiesta in attesa" do
      get mission_requests_path

      expect(response.body).to include(edit_mission_request_path(mission_request))
      expect(response.body).to include(confirm_destroy_mission_request_path(mission_request))
    end

    it "nasconde i bottoni modifica ed elimina per una richiesta approvata e ne colora il bordo di success" do
      mission_request.update!(request_approved: true)

      get mission_requests_path

      expect(response.body).not_to include(edit_mission_request_path(mission_request))
      expect(response.body).not_to include(confirm_destroy_mission_request_path(mission_request))
      expect(response.body).to include("border-success")
    end

    it "nasconde i bottoni modifica ed elimina per una richiesta respinta e ne colora il bordo di danger" do
      mission_request.update!(request_approved: false, rejection_motivation: "Dati incompleti")

      get mission_requests_path

      expect(response.body).not_to include(edit_mission_request_path(mission_request))
      expect(response.body).not_to include(confirm_destroy_mission_request_path(mission_request))
      expect(response.body).to include("border-danger")
    end
  end

  describe "GET /mission_requests/:id" do
    it "consente di vedere una propria richiesta missione" do
      get mission_request_path(mission_request)

      expect(response).to have_http_status(:ok)
    end

    it "impedisce di vedere la richiesta missione di un altro utente" do
      get mission_request_path(other_mission_request)

      expect(response).to have_http_status(:not_found)
    end

    it "mostra il bottone modifica per una richiesta in attesa" do
      get mission_request_path(mission_request)

      expect(response.body).to include(edit_mission_request_path(mission_request))
    end

    it "nasconde il bottone modifica per una richiesta già decisa" do
      mission_request.update!(request_approved: true)

      get mission_request_path(mission_request)

      expect(response.body).not_to include(edit_mission_request_path(mission_request))
    end
  end

  describe "POST /mission_requests" do
    let(:reason) { create(:reason, user: user) }
    let(:place) { create(:place, user: user) }
    let(:structure) { create(:structure, user: user) }
    let(:path) { create(:path, user: user) }
    let(:transport) { create(:transport, user: user) }

    it "crea una richiesta missione con i modelli memorizzati assegnata all'utente corrente" do
      expect {
        post mission_requests_path, params: {
          mission_request: {
            departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
            reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
            transport_id: transport.id
          }
        }
      }.to change(user.mission_requests, :count).by(1)
    end

    it "genera automaticamente il codice della richiesta" do
      post mission_requests_path, params: {
        mission_request: {
          departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
          reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
          transport_id: transport.id
        }
      }

      expect(user.mission_requests.last.name).to match(/\AMR-/)
    end

    it "crea una richiesta missione con i campi liberi" do
      expect {
        post mission_requests_path, params: {
          mission_request: {
            departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
            reason_fr: "Corso", place_fr: "Udine", structure_fr: "Sede regionale", path_fr: "Trieste-Udine",
            path_lenght_fr: 68.5, highway_cost_fr: 4.5, transport_id: transport.id
          }
        }
      }.to change(user.mission_requests, :count).by(1)
    end

    it "invia una mail ai validatori competenti" do
      create(:user, :manager, region: user.region, province: user.province, institute: user.institute, email: "manager@example.com")

      perform_enqueued_jobs do
        post mission_requests_path, params: {
          mission_request: {
            departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
            reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
            transport_id: transport.id
          }
        }
      end

      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  describe "GET /mission_requests/:id/edit" do
    it "nasconde la scelta della modalità di inserimento e mostra i campi memorizzati" do
      get edit_mission_request_path(mission_request)

      page = Nokogiri::HTML(response.body)
      expect(page.at_css("#input_mode_stored")).to be_nil
      expect(page.at_css('[data-mission-request-mode-target="stored"]')["class"]).not_to include("d-none")
      expect(page.at_css('[data-mission-request-mode-target="free"]')["class"]).to include("d-none")
    end

    it "mostra i campi liberi quando la richiesta è stata creata in quella modalità" do
      free_mission_request = create(:mission_request, :free_fields, user: user)

      get edit_mission_request_path(free_mission_request)

      page = Nokogiri::HTML(response.body)
      expect(page.at_css("#input_mode_stored")).to be_nil
      expect(page.at_css('[data-mission-request-mode-target="free"]')["class"]).not_to include("d-none")
      expect(page.at_css('[data-mission-request-mode-target="stored"]')["class"]).to include("d-none")
    end
  end

  describe "PATCH /mission_requests/:id" do
    it "aggiorna una propria richiesta missione" do
      patch mission_request_path(mission_request), params: { mission_request: { departure_date: Date.current + 1.day } }

      expect(mission_request.reload.departure_date).to eq(Date.current + 1.day)
    end

    it "impedisce di modificare una richiesta già approvata" do
      mission_request.update!(request_approved: true)

      patch mission_request_path(mission_request), params: { mission_request: { departure_date: Date.current + 1.day } }

      expect(response).to redirect_to(edit_mission_request_path(mission_request))
      expect(mission_request.reload.departure_date).not_to eq(Date.current + 1.day)
    end

    it "impedisce di modificare una richiesta già respinta" do
      mission_request.update!(request_approved: false, rejection_motivation: "Dati incompleti")

      patch mission_request_path(mission_request), params: { mission_request: { departure_date: Date.current + 1.day } }

      expect(response).to redirect_to(edit_mission_request_path(mission_request))
      expect(mission_request.reload.departure_date).not_to eq(Date.current + 1.day)
    end
  end

  describe "GET /mission_requests/:id/confirm_destroy" do
    it "mostra la pagina di conferma senza eliminare il record" do
      expect {
        get confirm_destroy_mission_request_path(mission_request)
      }.not_to change(MissionRequest, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /mission_requests/:id" do
    it "elimina una propria richiesta missione" do
      expect {
        delete mission_request_path(mission_request)
      }.to change(MissionRequest, :count).by(-1)
    end

    it "impedisce di eliminare la richiesta missione di un altro utente" do
      expect {
        delete mission_request_path(other_mission_request)
      }.not_to change(MissionRequest, :count)

      expect(response).to have_http_status(:not_found)
    end

    it "impedisce di eliminare una richiesta già approvata" do
      mission_request.update!(request_approved: true)

      expect {
        delete mission_request_path(mission_request)
      }.not_to change(MissionRequest, :count)

      expect(response).to redirect_to(confirm_destroy_mission_request_path(mission_request))
    end

    it "impedisce di eliminare una richiesta già respinta" do
      mission_request.update!(request_approved: false, rejection_motivation: "Dati incompleti")

      expect {
        delete mission_request_path(mission_request)
      }.not_to change(MissionRequest, :count)

      expect(response).to redirect_to(confirm_destroy_mission_request_path(mission_request))
    end
  end
end
