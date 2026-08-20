require 'rails_helper'

RSpec.describe "MissionRequests", type: :request do
  let!(:user) { create(:user, region: "FVG", province: "FVG") }
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
  end

  describe "POST /mission_requests" do
    let(:reason) { create(:reason, user: user) }
    let(:place) { create(:place, user: user) }
    let(:structure) { create(:structure, user: user) }
    let(:path) { create(:path, user: user) }

    it "crea una richiesta missione con i modelli memorizzati assegnata all'utente corrente" do
      expect {
        post mission_requests_path, params: {
          mission_request: {
            departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
            reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id
          }
        }
      }.to change(user.mission_requests, :count).by(1)
    end

    it "genera automaticamente il codice della richiesta" do
      post mission_requests_path, params: {
        mission_request: {
          departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
          reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id
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
            path_lenght_fr: 68.5, highway_cost_fr: 4.5
          }
        }
      }.to change(user.mission_requests, :count).by(1)
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
  end
end
