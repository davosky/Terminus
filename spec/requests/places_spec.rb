require 'rails_helper'

RSpec.describe "Places", type: :request do
  let(:user) { create(:user) }
  let!(:place) { create(:place, user: user, name: "Udine", position: 2) }
  let!(:first) { create(:place, user: user, name: "Gorizia", position: 1) }
  let!(:foreign) { create(:place, name: "Luogo altrui") }
  let(:valid_params) { { name: "Venezia", position: 3 } }

  def sign_in_as(account)
    post user_session_path, params: { user: { username: account.username, password: account.password } }
  end

  context "quando l'utente non è autenticato" do
    it "reindirizza al login" do
      get places_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "quando l'utente è autenticato" do
    before { sign_in_as(user) }

    it "elenca solo i propri luoghi, in ordine di posizione" do
      get places_path
      expect(response.body).to match(/Gorizia.*Udine/m)
      expect(response.body).not_to include("translation_missing")
      expect(response.body).not_to include("Luogo altrui")
    end

    it "vede la voce Luoghi nel dropdown Utility" do
      get root_path
      expect(response.body).to include("fa-city", "Luoghi", %(href="#{places_path}"))
    end

    it "apre new, show, edit e confirm_destroy dentro la finestra modale" do
      [ new_place_path, place_path(place), edit_place_path(place), confirm_destroy_place_path(place) ].each do |path|
        get path
        expect(response.body).to include('<turbo-frame id="modal">', "<dialog")
        expect(response.body).not_to include("translation_missing")
      end
    end

    it "usa la misura unica .btn per tutti i bottoni fuori dalla navbar" do
      [ new_place_path, edit_place_path(place), confirm_destroy_place_path(place) ].each do |path|
        get path
        buttons = css_select("button") - css_select("nav button")
        expect(buttons).not_to be_empty
        expect(buttons).to all(satisfy { |button| button["class"].to_s.split.include?("btn") })
      end
    end

    it "crea un luogo proprio" do
      post places_path, params: { place: valid_params.merge(user_code: foreign.user_code) }
      expect(response).to redirect_to(places_path)
      expect(user.places.find_by(name: "Venezia")).to have_attributes(position: 3)
    end

    it "mostra gli errori quando i dati non sono validi" do
      post places_path, params: { place: valid_params.merge(name: "") }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("<dialog", 'role="alert"')
    end

    it "modifica un proprio luogo" do
      patch place_path(place), params: { place: { name: "Udine Nord" } }
      expect(place.reload.name).to eq("Udine Nord")
    end

    it "chiede conferma prima di eliminare" do
      get confirm_destroy_place_path(place)
      expect(response.body).to include("Stai per eliminare definitivamente il luogo", "Udine", "Annulla")
      expect(Place.exists?(place.id)).to be(true)
    end

    it "elimina un proprio luogo" do
      delete place_path(place)
      expect(response).to redirect_to(places_path)
      expect(Place.exists?(place.id)).to be(false)
    end

    it "non raggiunge i luoghi degli altri utenti" do
      [ -> { get place_path(foreign) }, -> { get edit_place_path(foreign) },
        -> { patch place_path(foreign), params: { place: { name: "X" } } },
        -> { delete place_path(foreign) } ].each do |request|
        request.call
        expect(response).to have_http_status(:not_found)
      end
      expect(foreign.reload.name).to eq("Luogo altrui")
    end
  end

  context "quando l'utente è amministratore" do
    let(:user) { create(:user, :admin) }

    before { sign_in_as(user) }

    it "non raggiunge i luoghi degli altri dalle pagine normali" do
      patch place_path(foreign), params: { place: { name: "X" } }
      expect(response).to have_http_status(:not_found)
      expect(foreign.reload.name).to eq("Luogo altrui")
    end

    it "li elenca e li modifica da Madmin" do
      get madmin_places_path
      expect(response.body).to include("Luogo altrui")
      expect(response.body).not_to include("Translation missing")
      patch madmin_place_path(foreign), params: { place: { name: "Luogo corretto" } }
      expect(foreign.reload.name).to eq("Luogo corretto")
    end

    it "crea da Madmin un luogo scegliendo l'utente tramite user_code" do
      target = create(:user)
      get new_madmin_place_path
      expect(response).to have_http_status(:ok)
      post madmin_places_path, params: { place: valid_params.merge(user_code: target.reload.user_code) }
      expect(target.places.pluck(:name)).to eq([ "Venezia" ])
    end
  end
end
