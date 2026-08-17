require 'rails_helper'

RSpec.describe "Transports", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:transport) { create(:transport, user: user) }
  let!(:other_transport) { create(:transport, user: other_user) }

  before { sign_in user }

  describe "GET /transports" do
    it "mostra solo i trasporti dell'utente corrente" do
      get transports_path

      expect(response.body).to include(transport.name)
      expect(response.body).not_to include(other_transport.name)
    end
  end

  describe "GET /transports/:id" do
    it "consente di vedere un proprio trasporto" do
      get transport_path(transport)

      expect(response).to have_http_status(:ok)
    end

    it "impedisce di vedere il trasporto di un altro utente" do
      get transport_path(other_transport)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /transports" do
    it "crea un trasporto assegnato all'utente corrente" do
      expect {
        post transports_path, params: { transport: attributes_for(:transport) }
      }.to change(user.transports, :count).by(1)
    end
  end

  describe "PATCH /transports/:id" do
    it "aggiorna un proprio trasporto" do
      patch transport_path(transport), params: { transport: { name: "Nuovo Nome" } }

      expect(transport.reload.name).to eq("Nuovo Nome")
    end

    it "impedisce di modificare un record di sistema" do
      protected_transport = create(:transport, user: user, name: "Veicolo Privato")

      patch transport_path(protected_transport), params: { transport: { name: "Hackerato" } }

      expect(protected_transport.reload.name).to eq("Veicolo Privato")
      expect(response).to redirect_to(edit_transport_path(protected_transport))
    end
  end

  describe "GET /transports/:id/confirm_destroy" do
    it "mostra la pagina di conferma senza eliminare il record" do
      expect {
        get confirm_destroy_transport_path(transport)
      }.not_to change(Transport, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /transports/:id" do
    it "elimina un proprio trasporto" do
      expect {
        delete transport_path(transport)
      }.to change(Transport, :count).by(-1)
    end

    it "impedisce di eliminare il trasporto di un altro utente" do
      expect {
        delete transport_path(other_transport)
      }.not_to change(Transport, :count)

      expect(response).to have_http_status(:not_found)
    end

    it "impedisce di eliminare un record di sistema" do
      protected_transport = create(:transport, user: user, name: "Veicolo Aziendale")

      expect {
        delete transport_path(protected_transport)
      }.not_to change(Transport, :count)

      expect(response).to redirect_to(confirm_destroy_transport_path(protected_transport))
    end
  end
end
