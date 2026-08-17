require 'rails_helper'

RSpec.describe "Structures", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:structure) { create(:structure, user: user) }
  let!(:other_structure) { create(:structure, user: other_user) }

  before { sign_in user }

  describe "GET /structures" do
    it "mostra solo le strutture dell'utente corrente" do
      get structures_path

      expect(response.body).to include(structure.name)
      expect(response.body).not_to include(other_structure.name)
    end
  end

  describe "GET /structures/:id" do
    it "consente di vedere una propria struttura" do
      get structure_path(structure)

      expect(response).to have_http_status(:ok)
    end

    it "impedisce di vedere la struttura di un altro utente" do
      get structure_path(other_structure)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /structures" do
    it "crea una struttura assegnata all'utente corrente" do
      expect {
        post structures_path, params: { structure: attributes_for(:structure) }
      }.to change(user.structures, :count).by(1)
    end
  end

  describe "PATCH /structures/:id" do
    it "aggiorna una propria struttura" do
      patch structure_path(structure), params: { structure: { name: "Nuovo Nome" } }

      expect(structure.reload.name).to eq("Nuovo Nome")
    end
  end

  describe "GET /structures/:id/confirm_destroy" do
    it "mostra la pagina di conferma senza eliminare il record" do
      expect {
        get confirm_destroy_structure_path(structure)
      }.not_to change(Structure, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /structures/:id" do
    it "elimina una propria struttura" do
      expect {
        delete structure_path(structure)
      }.to change(Structure, :count).by(-1)
    end

    it "impedisce di eliminare la struttura di un altro utente" do
      expect {
        delete structure_path(other_structure)
      }.not_to change(Structure, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
