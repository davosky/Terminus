require 'rails_helper'

RSpec.describe "Vehicles", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:vehicle) { create(:vehicle, user: user) }
  let!(:other_vehicle) { create(:vehicle, user: other_user) }

  before { sign_in user }

  describe "GET /vehicles" do
    it "mostra solo i veicoli dell'utente corrente" do
      get vehicles_path

      expect(response.body).to include(vehicle.name)
      expect(response.body).not_to include(other_vehicle.licence_plate)
    end
  end

  describe "GET /vehicles/:id" do
    it "consente di vedere un proprio veicolo" do
      get vehicle_path(vehicle)

      expect(response).to have_http_status(:ok)
    end

    it "impedisce di vedere il veicolo di un altro utente" do
      get vehicle_path(other_vehicle)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /vehicles" do
    it "crea un veicolo assegnato all'utente corrente" do
      expect {
        post vehicles_path, params: { vehicle: attributes_for(:vehicle) }
      }.to change(user.vehicles, :count).by(1)
    end
  end

  describe "GET /vehicles/:id/confirm_destroy" do
    it "mostra la pagina di conferma senza eliminare il record" do
      expect {
        get confirm_destroy_vehicle_path(vehicle)
      }.not_to change(Vehicle, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /vehicles/:id" do
    it "elimina un proprio veicolo" do
      expect {
        delete vehicle_path(vehicle)
      }.to change(Vehicle, :count).by(-1)
    end

    it "impedisce di eliminare il veicolo di un altro utente" do
      expect {
        delete vehicle_path(other_vehicle)
      }.not_to change(Vehicle, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
