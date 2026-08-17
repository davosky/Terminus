require 'rails_helper'

RSpec.describe "Places", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:place) { create(:place, user: user) }
  let!(:other_place) { create(:place, user: other_user) }

  before { sign_in user }

  describe "GET /places" do
    it "mostra solo i luoghi dell'utente corrente" do
      get places_path

      expect(response.body).to include(place.name)
      expect(response.body).not_to include(other_place.name)
    end
  end

  describe "GET /places/:id" do
    it "consente di vedere un proprio luogo" do
      get place_path(place)

      expect(response).to have_http_status(:ok)
    end

    it "impedisce di vedere il luogo di un altro utente" do
      get place_path(other_place)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /places" do
    it "crea un luogo assegnato all'utente corrente" do
      expect {
        post places_path, params: { place: attributes_for(:place) }
      }.to change(user.places, :count).by(1)
    end
  end

  describe "PATCH /places/:id" do
    it "aggiorna un proprio luogo" do
      patch place_path(place), params: { place: { name: "Nuovo Nome" } }

      expect(place.reload.name).to eq("Nuovo Nome")
    end
  end

  describe "GET /places/:id/confirm_destroy" do
    it "mostra la pagina di conferma senza eliminare il record" do
      expect {
        get confirm_destroy_place_path(place)
      }.not_to change(Place, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /places/:id" do
    it "elimina un proprio luogo" do
      expect {
        delete place_path(place)
      }.to change(Place, :count).by(-1)
    end

    it "impedisce di eliminare il luogo di un altro utente" do
      expect {
        delete place_path(other_place)
      }.not_to change(Place, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
