require 'rails_helper'

RSpec.describe "Vehicles", type: :request do
  let(:user) { create(:user) }
  let!(:vehicle) { create(:vehicle, user: user, producer: "Fiat", name: "Panda", position: 2) }
  let!(:first) { create(:vehicle, user: user, producer: "Renault", name: "Clio", position: 1) }
  let!(:foreign) { create(:vehicle, name: "Auto altrui") }
  let(:valid_params) do
    { producer: "Toyota", name: "Yaris", licence_plate: "ZZ999ZZ", power: "Ibrido", cost_per_km: "0.38", position: 3 }
  end

  def sign_in_as(account)
    post user_session_path, params: { user: { username: account.username, password: account.password } }
  end

  context "quando l'utente non è autenticato" do
    it "reindirizza al login" do
      get vehicles_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "quando l'utente è autenticato" do
    before { sign_in_as(user) }

    it "elenca solo i propri veicoli, in ordine di posizione" do
      get vehicles_path
      expect(response.body).to match(/Clio.*Panda/m)
      expect(response.body).not_to include("translation_missing")
      expect(response.body).not_to include("Auto altrui")
    end

    it "vede la voce Veicoli nel dropdown Utility" do
      get root_path
      expect(response.body).to include("fa-car", "Veicoli", %(href="#{vehicles_path}"))
    end

    it "apre new, show, edit e confirm_destroy dentro la finestra modale" do
      [ new_vehicle_path, vehicle_path(vehicle), edit_vehicle_path(vehicle), confirm_destroy_vehicle_path(vehicle) ].each do |path|
        get path
        expect(response.body).to include('<turbo-frame id="modal">', "<dialog")
        expect(response.body).not_to include("translation_missing")
      end
    end

    it "usa la misura unica .btn per tutti i bottoni fuori dalla navbar" do
      [ new_vehicle_path, edit_vehicle_path(vehicle), confirm_destroy_vehicle_path(vehicle) ].each do |path|
        get path
        buttons = css_select("button") - css_select("nav button")
        expect(buttons).not_to be_empty
        expect(buttons).to all(satisfy { |button| button["class"].to_s.split.include?("btn") })
      end
    end

    it "propone le quattro alimentazioni nel form" do
      get new_vehicle_path
      expect(css_select("select#vehicle_power option").map(&:text)).to eq([ "", *Vehicle::POWERS ])
    end

    it "crea un veicolo proprio" do
      post vehicles_path, params: { vehicle: valid_params.merge(user_code: foreign.user_code) }
      expect(response).to redirect_to(vehicles_path)
      expect(user.vehicles.find_by(name: "Yaris")).to have_attributes(power: "Ibrido", cost_per_km: 0.38, position: 3)
    end

    it "mostra gli errori quando i dati non sono validi" do
      post vehicles_path, params: { vehicle: valid_params.merge(licence_plate: "") }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("<dialog", 'role="alert"')
    end

    it "modifica un proprio veicolo" do
      patch vehicle_path(vehicle), params: { vehicle: { name: "Panda Cross" } }
      expect(vehicle.reload.name).to eq("Panda Cross")
    end

    it "chiede conferma prima di eliminare" do
      get confirm_destroy_vehicle_path(vehicle)
      expect(response.body).to include("Stai per eliminare definitivamente il veicolo", "Fiat Panda", "Annulla")
      expect(Vehicle.exists?(vehicle.id)).to be(true)
    end

    it "elimina un proprio veicolo" do
      delete vehicle_path(vehicle)
      expect(response).to redirect_to(vehicles_path)
      expect(Vehicle.exists?(vehicle.id)).to be(false)
    end

    it "non raggiunge i veicoli degli altri utenti" do
      [ -> { get vehicle_path(foreign) }, -> { get edit_vehicle_path(foreign) },
        -> { patch vehicle_path(foreign), params: { vehicle: { name: "X" } } },
        -> { delete vehicle_path(foreign) } ].each do |request|
        request.call
        expect(response).to have_http_status(:not_found)
      end
      expect(foreign.reload.name).to eq("Auto altrui")
    end
  end

  context "quando l'utente è amministratore" do
    let(:user) { create(:user, :admin) }

    before { sign_in_as(user) }

    it "non raggiunge i veicoli degli altri dalle pagine normali" do
      patch vehicle_path(foreign), params: { vehicle: { name: "X" } }
      expect(response).to have_http_status(:not_found)
      expect(foreign.reload.name).to eq("Auto altrui")
    end

    it "li elenca e li modifica da Madmin" do
      get madmin_vehicles_path
      expect(response.body).to include("Auto altrui")
      expect(response.body).not_to include("Translation missing")
      patch madmin_vehicle_path(foreign), params: { vehicle: { name: "Auto corretta" } }
      expect(foreign.reload.name).to eq("Auto corretta")
    end

    it "crea da Madmin un veicolo scegliendo l'utente tramite user_code" do
      target = create(:user)
      get new_madmin_vehicle_path
      expect(response).to have_http_status(:ok)
      post madmin_vehicles_path, params: { vehicle: valid_params.merge(user_code: target.reload.user_code) }
      expect(target.vehicles.pluck(:name)).to eq([ "Yaris" ])
    end
  end
end
