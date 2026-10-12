require 'rails_helper'

RSpec.describe "Paths", type: :request do
  let(:user) { create(:user) }
  let!(:path) { create(:path, user: user, name: "Trieste - Udine", position: 2) }
  let!(:first) { create(:path, user: user, name: "Gorizia - Pordenone", position: 1) }
  let!(:foreign) { create(:path, name: "Percorso altrui") }
  let(:valid_params) { { name: "Trieste - Venezia", lenght: "158.4", highway_cost: "12.30", position: 3 } }

  def sign_in_as(account)
    post user_session_path, params: { user: { username: account.username, password: account.password } }
  end

  context "quando l'utente non è autenticato" do
    it "reindirizza al login" do
      get paths_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "quando l'utente è autenticato" do
    before { sign_in_as(user) }

    it "elenca solo i propri percorsi, in ordine di posizione" do
      get paths_path
      expect(response.body).to match(/Gorizia - Pordenone.*Trieste - Udine/m)
      expect(response.body).not_to include("translation_missing")
      expect(response.body).not_to include("Percorso altrui")
    end

    it "vede la voce Percorsi nel dropdown Utility" do
      get root_path
      expect(response.body).to include("fa-road", "Percorsi", %(href="#{paths_path}"))
    end

    it "apre new, show, edit e confirm_destroy dentro la finestra modale" do
      [ new_path_path, path_path(path), edit_path_path(path), confirm_destroy_path_path(path) ].each do |url|
        get url
        expect(response.body).to include('<turbo-frame id="modal">', "<dialog")
        expect(response.body).not_to include("translation_missing")
      end
    end

    it "usa la misura unica .btn per tutti i bottoni fuori dalla navbar" do
      [ new_path_path, edit_path_path(path), confirm_destroy_path_path(path) ].each do |url|
        get url
        buttons = css_select("button") - css_select("nav button")
        expect(buttons).not_to be_empty
        expect(buttons).to all(satisfy { |button| button["class"].to_s.split.include?("btn") })
      end
    end

    it "crea un percorso proprio" do
      post paths_path, params: { path: valid_params.merge(user_code: foreign.user_code) }
      expect(response).to redirect_to(paths_path)
      expect(user.paths.find_by(name: "Trieste - Venezia")).to have_attributes(lenght: 158.4, highway_cost: 12.3, position: 3)
    end

    it "accetta un costo autostrada vuoto" do
      post paths_path, params: { path: valid_params.merge(highway_cost: "") }
      expect(user.paths.find_by(name: "Trieste - Venezia").highway_cost).to eq(0)
    end

    it "mostra gli errori quando i dati non sono validi" do
      post paths_path, params: { path: valid_params.merge(lenght: "") }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("<dialog", 'role="alert"')
    end

    it "modifica un proprio percorso" do
      patch path_path(path), params: { path: { name: "Trieste - Udine Nord" } }
      expect(path.reload.name).to eq("Trieste - Udine Nord")
    end

    it "chiede conferma prima di eliminare" do
      get confirm_destroy_path_path(path)
      expect(response.body).to include("Stai per eliminare definitivamente il percorso", "Trieste - Udine", "Annulla")
      expect(Path.exists?(path.id)).to be(true)
    end

    it "elimina un proprio percorso" do
      delete path_path(path)
      expect(response).to redirect_to(paths_path)
      expect(Path.exists?(path.id)).to be(false)
    end

    it "non raggiunge i percorsi degli altri utenti" do
      [ -> { get path_path(foreign) }, -> { get edit_path_path(foreign) },
        -> { patch path_path(foreign), params: { path: { name: "X" } } },
        -> { delete path_path(foreign) } ].each do |request|
        request.call
        expect(response).to have_http_status(:not_found)
      end
      expect(foreign.reload.name).to eq("Percorso altrui")
    end
  end

  context "quando l'utente è amministratore" do
    let(:user) { create(:user, :admin) }

    before { sign_in_as(user) }

    it "non raggiunge i percorsi degli altri dalle pagine normali" do
      patch path_path(foreign), params: { path: { name: "X" } }
      expect(response).to have_http_status(:not_found)
      expect(foreign.reload.name).to eq("Percorso altrui")
    end

    it "li elenca e li modifica da Madmin" do
      get madmin_paths_path
      expect(response.body).to include("Percorso altrui")
      expect(response.body).not_to include("Translation missing")
      patch madmin_path_path(foreign), params: { path: { name: "Percorso corretto" } }
      expect(foreign.reload.name).to eq("Percorso corretto")
    end

    it "crea da Madmin un percorso scegliendo l'utente tramite user_code" do
      target = create(:user)
      get new_madmin_path_path
      expect(response).to have_http_status(:ok)
      post madmin_paths_path, params: { path: valid_params.merge(user_code: target.reload.user_code) }
      expect(target.paths.pluck(:name)).to eq([ "Trieste - Venezia" ])
    end
  end
end
