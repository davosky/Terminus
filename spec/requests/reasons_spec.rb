require 'rails_helper'

RSpec.describe "Reasons", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:reason) { create(:reason, user: user) }
  let!(:other_reason) { create(:reason, user: other_user) }

  before { sign_in user }

  describe "GET /reasons" do
    it "mostra solo i motivi missione dell'utente corrente" do
      get reasons_path

      expect(response.body).to include(reason.name)
      expect(response.body).not_to include(other_reason.name)
    end
  end

  describe "GET /reasons/:id" do
    it "consente di vedere un proprio motivo missione" do
      get reason_path(reason)

      expect(response).to have_http_status(:ok)
    end

    it "impedisce di vedere il motivo missione di un altro utente" do
      get reason_path(other_reason)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /reasons" do
    it "crea un motivo missione assegnato all'utente corrente" do
      expect {
        post reasons_path, params: { reason: attributes_for(:reason) }
      }.to change(user.reasons, :count).by(1)
    end
  end

  describe "PATCH /reasons/:id" do
    it "aggiorna un proprio motivo missione" do
      patch reason_path(reason), params: { reason: { name: "Nuovo Nome" } }

      expect(reason.reload.name).to eq("Nuovo Nome")
    end
  end

  describe "GET /reasons/:id/confirm_destroy" do
    it "mostra la pagina di conferma senza eliminare il record" do
      expect {
        get confirm_destroy_reason_path(reason)
      }.not_to change(Reason, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /reasons/:id" do
    it "elimina un proprio motivo missione" do
      expect {
        delete reason_path(reason)
      }.to change(Reason, :count).by(-1)
    end

    it "impedisce di eliminare il motivo missione di un altro utente" do
      expect {
        delete reason_path(other_reason)
      }.not_to change(Reason, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
