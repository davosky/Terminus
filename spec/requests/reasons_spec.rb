require 'rails_helper'

RSpec.describe "Reasons", type: :request do
  let(:user) { create(:user) }
  let!(:reason) { create(:reason, user: user, name: "Riunione", position: 2) }
  let!(:first) { create(:reason, user: user, name: "Assemblea", position: 1) }
  let!(:foreign) { create(:reason, name: "Motivo altrui") }
  let(:valid_params) { { name: "Formazione", position: 3 } }

  def sign_in_as(account)
    post user_session_path, params: { user: { username: account.username, password: account.password } }
  end

  context "quando l'utente non è autenticato" do
    it "reindirizza al login" do
      get reasons_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "quando l'utente è autenticato" do
    before { sign_in_as(user) }

    it "elenca solo i propri motivi missione, in ordine di posizione" do
      get reasons_path
      expect(response.body).to match(/Assemblea.*Riunione/m)
      expect(response.body).not_to include("translation_missing")
      expect(response.body).not_to include("Motivo altrui")
    end

    it "vede la voce Motivi Missione nel dropdown Utility" do
      get root_path
      expect(response.body).to include("fa-file-contract", "Motivi Missione", %(href="#{reasons_path}"))
    end

    it "apre new, show, edit e confirm_destroy dentro la finestra modale" do
      [ new_reason_path, reason_path(reason), edit_reason_path(reason), confirm_destroy_reason_path(reason) ].each do |path|
        get path
        expect(response.body).to include('<turbo-frame id="modal">', "<dialog")
        expect(response.body).not_to include("translation_missing")
      end
    end

    it "usa la misura unica .btn per tutti i bottoni fuori dalla navbar" do
      [ new_reason_path, edit_reason_path(reason), confirm_destroy_reason_path(reason) ].each do |path|
        get path
        buttons = css_select("button") - css_select("nav button")
        expect(buttons).not_to be_empty
        expect(buttons).to all(satisfy { |button| button["class"].to_s.split.include?("btn") })
      end
    end

    it "crea un motivo missione proprio" do
      post reasons_path, params: { reason: valid_params.merge(user_code: foreign.user_code) }
      expect(response).to redirect_to(reasons_path)
      expect(user.reasons.find_by(name: "Formazione")).to have_attributes(position: 3)
    end

    it "mostra gli errori quando i dati non sono validi" do
      post reasons_path, params: { reason: valid_params.merge(name: "") }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("<dialog", 'role="alert"')
    end

    it "modifica un proprio motivo missione" do
      patch reason_path(reason), params: { reason: { name: "Riunione Regionale" } }
      expect(reason.reload.name).to eq("Riunione Regionale")
    end

    it "chiede conferma prima di eliminare" do
      get confirm_destroy_reason_path(reason)
      expect(response.body).to include("Stai per eliminare definitivamente il motivo missione", "Riunione", "Annulla")
      expect(Reason.exists?(reason.id)).to be(true)
    end

    it "elimina un proprio motivo missione" do
      delete reason_path(reason)
      expect(response).to redirect_to(reasons_path)
      expect(Reason.exists?(reason.id)).to be(false)
    end

    it "non raggiunge i motivi missione degli altri utenti" do
      [ -> { get reason_path(foreign) }, -> { get edit_reason_path(foreign) },
        -> { patch reason_path(foreign), params: { reason: { name: "X" } } },
        -> { delete reason_path(foreign) } ].each do |request|
        request.call
        expect(response).to have_http_status(:not_found)
      end
      expect(foreign.reload.name).to eq("Motivo altrui")
    end
  end

  context "quando l'utente è amministratore" do
    let(:user) { create(:user, :admin) }

    before { sign_in_as(user) }

    it "non raggiunge i motivi missione degli altri dalle pagine normali" do
      patch reason_path(foreign), params: { reason: { name: "X" } }
      expect(response).to have_http_status(:not_found)
      expect(foreign.reload.name).to eq("Motivo altrui")
    end

    it "li elenca e li modifica da Madmin" do
      get madmin_reasons_path
      expect(response.body).to include("Motivo altrui")
      expect(response.body).not_to include("Translation missing")
      patch madmin_reason_path(foreign), params: { reason: { name: "Motivo corretto" } }
      expect(foreign.reload.name).to eq("Motivo corretto")
    end

    it "crea da Madmin un motivo missione scegliendo l'utente tramite user_code" do
      target = create(:user)
      get new_madmin_reason_path
      expect(response).to have_http_status(:ok)
      post madmin_reasons_path, params: { reason: valid_params.merge(user_code: target.reload.user_code) }
      expect(target.reasons.pluck(:name)).to eq([ "Formazione" ])
    end
  end
end
