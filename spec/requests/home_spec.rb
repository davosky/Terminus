require 'rails_helper'

RSpec.describe "Home", type: :request do
  let(:user) { create(:user, username: "davo", first_name: "Davo", last_name: "Davosky") }

  context "quando l'utente non è autenticato" do
    it "reindirizza al login" do
      get root_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "quando l'utente accede con username e password" do
    before { post user_session_path, params: { user: { username: "DAVO", password: user.password } } }

    it "mostra la home con il suo nome e il messaggio flash a scomparsa" do
      follow_redirect!
      expect(response.body).to include("Davo Davosky", "Rimborsi Spese e Assenze", 'data-controller="flash"')
    end

    it "può uscire" do
      delete destroy_user_session_path
      get root_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "quando la password è errata" do
    before { post user_session_path, params: { user: { username: user.username, password: "sbagliata" } } }

    it "rifiuta l'accesso senza mostrare messaggi" do
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).not_to include('data-controller="flash"')
    end
  end

  context "quando l'utente sbaglia la password dieci volte" do
    before do
      10.times { post user_session_path, params: { user: { username: user.username, password: "sbagliata" } } }
      post user_session_path, params: { user: { username: user.username, password: user.password } }
    end

    it "blocca l'account anche con la password corretta" do
      expect(user.reload).to be_access_locked
      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
