require 'rails_helper'

RSpec.describe "Paths", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:path) { create(:path, user: user) }
  let!(:other_path) { create(:path, user: other_user) }

  before { sign_in user }

  describe "GET /paths" do
    it "mostra solo i percorsi dell'utente corrente" do
      get paths_path

      expect(response.body).to include(path.name)
      expect(response.body).not_to include(other_path.name)
    end
  end

  describe "GET /paths/:id" do
    it "consente di vedere un proprio percorso" do
      get path_path(path)

      expect(response).to have_http_status(:ok)
    end

    it "impedisce di vedere il percorso di un altro utente" do
      get path_path(other_path)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /paths" do
    it "crea un percorso assegnato all'utente corrente" do
      expect {
        post paths_path, params: { path: attributes_for(:path) }
      }.to change(user.paths, :count).by(1)
    end
  end

  describe "PATCH /paths/:id" do
    it "aggiorna un proprio percorso" do
      patch path_path(path), params: { path: { name: "Nuovo Nome" } }

      expect(path.reload.name).to eq("Nuovo Nome")
    end
  end

  describe "GET /paths/:id/confirm_destroy" do
    it "mostra la pagina di conferma senza eliminare il record" do
      expect {
        get confirm_destroy_path_path(path)
      }.not_to change(Path, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /paths/:id" do
    it "elimina un proprio percorso" do
      expect {
        delete path_path(path)
      }.to change(Path, :count).by(-1)
    end

    it "impedisce di eliminare il percorso di un altro utente" do
      expect {
        delete path_path(other_path)
      }.not_to change(Path, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
