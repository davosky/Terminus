require 'rails_helper'

RSpec.describe "Structures", type: :request do
  let(:user) { create(:user) }
  let!(:structure) { create(:structure, user: user, name: "Sede Udine", position: 2) }
  let!(:first) { create(:structure, user: user, name: "Sede Gorizia", position: 1) }
  let!(:foreign) { create(:structure, name: "Struttura altrui") }
  let(:valid_params) { { name: "Sede Venezia", position: 3 } }

  def sign_in_as(account)
    post user_session_path, params: { user: { username: account.username, password: account.password } }
  end

  context "quando l'utente non è autenticato" do
    it "reindirizza al login" do
      get structures_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "quando l'utente è autenticato" do
    before { sign_in_as(user) }

    it "elenca solo i proprie strutture, in ordine di posizione" do
      get structures_path
      expect(response.body).to match(/Sede Gorizia.*Sede Udine/m)
      expect(response.body).not_to include("translation_missing")
      expect(response.body).not_to include("Struttura altrui")
    end

    it "vede la voce Strutture nel dropdown Utility" do
      get root_path
      expect(response.body).to include("fa-building", "Strutture", %(href="#{structures_path}"))
    end

    it "apre new, show, edit e confirm_destroy dentro la finestra modale" do
      [ new_structure_path, structure_path(structure), edit_structure_path(structure), confirm_destroy_structure_path(structure) ].each do |path|
        get path
        expect(response.body).to include('<turbo-frame id="modal">', "<dialog")
        expect(response.body).not_to include("translation_missing")
      end
    end

    it "usa la misura unica .btn per tutti i bottoni fuori dalla navbar" do
      [ new_structure_path, edit_structure_path(structure), confirm_destroy_structure_path(structure) ].each do |path|
        get path
        buttons = css_select("button") - css_select("nav button")
        expect(buttons).not_to be_empty
        expect(buttons).to all(satisfy { |button| button["class"].to_s.split.include?("btn") })
      end
    end

    it "crea una struttura propria" do
      post structures_path, params: { structure: valid_params.merge(user_code: foreign.user_code) }
      expect(response).to redirect_to(structures_path)
      expect(user.structures.find_by(name: "Sede Venezia")).to have_attributes(position: 3)
    end

    it "mostra gli errori quando i dati non sono validi" do
      post structures_path, params: { structure: valid_params.merge(name: "") }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("<dialog", 'role="alert"')
    end

    it "modifica una propria struttura" do
      patch structure_path(structure), params: { structure: { name: "Sede Nord" } }
      expect(structure.reload.name).to eq("Sede Nord")
    end

    it "chiede conferma prima di eliminare" do
      get confirm_destroy_structure_path(structure)
      expect(response.body).to include("Stai per eliminare definitivamente la struttura", "Sede Udine", "Annulla")
      expect(Structure.exists?(structure.id)).to be(true)
    end

    it "elimina una propria struttura" do
      delete structure_path(structure)
      expect(response).to redirect_to(structures_path)
      expect(Structure.exists?(structure.id)).to be(false)
    end

    it "non raggiunge le strutture degli altri utenti" do
      [ -> { get structure_path(foreign) }, -> { get edit_structure_path(foreign) },
        -> { patch structure_path(foreign), params: { structure: { name: "X" } } },
        -> { delete structure_path(foreign) } ].each do |request|
        request.call
        expect(response).to have_http_status(:not_found)
      end
      expect(foreign.reload.name).to eq("Struttura altrui")
    end
  end

  context "quando l'utente è amministratore" do
    let(:user) { create(:user, :admin) }

    before { sign_in_as(user) }

    it "non raggiunge le strutture degli altri dalle pagine normali" do
      patch structure_path(foreign), params: { structure: { name: "X" } }
      expect(response).to have_http_status(:not_found)
      expect(foreign.reload.name).to eq("Struttura altrui")
    end

    it "le elenca e le modifica da Madmin" do
      get madmin_structures_path
      expect(response.body).to include("Struttura altrui")
      expect(response.body).not_to include("Translation missing")
      patch madmin_structure_path(foreign), params: { structure: { name: "Struttura corretta" } }
      expect(foreign.reload.name).to eq("Struttura corretta")
    end

    it "crea da Madmin una struttura scegliendo l'utente tramite user_code" do
      target = create(:user)
      get new_madmin_structure_path
      expect(response).to have_http_status(:ok)
      post madmin_structures_path, params: { structure: valid_params.merge(user_code: target.reload.user_code) }
      expect(target.structures.pluck(:name)).to eq([ "Sede Venezia" ])
    end
  end
end
