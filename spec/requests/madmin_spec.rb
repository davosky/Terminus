require 'rails_helper'

RSpec.describe "Madmin", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:target) { create(:user, username: "mario") }

  def sign_in_as(user)
    post user_session_path, params: { user: { username: user.username, password: user.password } }
  end

  context "quando l'utente non è autenticato" do
    it "reindirizza al login" do
      get madmin_root_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "quando l'utente non è amministratore" do
    before { sign_in_as(create(:user)) }

    it "nega l'accesso alla dashboard" do
      get madmin_root_path
      expect(response).to redirect_to(root_path)
    end

    it "non vede il link Amministrazione nella navbar" do
      get root_path
      expect(response.body).not_to include("Amministrazione", madmin_root_path)
    end

    it "nega la modifica degli utenti" do
      patch madmin_user_path(target), params: { user: { admin: true } }
      expect(target.reload).not_to be_admin
    end
  end

  context "quando l'utente è amministratore" do
    before { sign_in_as(admin) }

    it "vede il link Amministrazione nella navbar" do
      get root_path
      expect(response.body).to include("Amministrazione", %(href="#{madmin_root_path}"))
    end

    it "carica lo stile Terminus dopo quello di Madmin" do
      get madmin_root_path
      expect(response.body).to match(%r{/assets/madmin/application-.*/assets/madmin_terminus-}m)
    end

    it "mostra la dashboard in italiano" do
      get madmin_root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to match(/translation missing/i)
    end

    it "elenca gli utenti senza esporre l'hash della password" do
      get madmin_user_path(target)
      expect(response.body).to include("mario")
      expect(response.body).not_to include(target.encrypted_password)
    end

    it "mostra i form di creazione e modifica" do
      get new_madmin_user_path
      expect(response).to have_http_status(:ok)
      get edit_madmin_user_path(target)
      expect(response.body).not_to match(/translation missing/i)
    end

    it "modifica un utente lasciando invariata la password vuota" do
      patch madmin_user_path(target), params: { user: { first_name: "Luigi", password: "" } }
      expect(target.reload.first_name).to eq("Luigi")
      expect(target.valid_password?("pAssword1234567")).to be(true)
    end

    it "cambia la password quando viene indicata" do
      patch madmin_user_path(target), params: { user: { password: "nuovaPassword123" } }
      expect(target.reload.valid_password?("nuovaPassword123")).to be(true)
    end
  end
end
