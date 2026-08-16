require 'rails_helper'

RSpec.describe "Vehicles", type: :system do
  let!(:user) { create(:user, username: "mario") }
  let!(:other_user) { create(:user, username: "luigi") }
  let!(:vehicle) { create(:vehicle, user: user, name: "Panda", licence_plate: "AA111BB") }
  let!(:other_vehicle) { create(:vehicle, user: other_user, name: "Punto", licence_plate: "ZZ999YY") }

  before { login_as(user) }

  it "mostra solo i veicoli dell'utente corrente nell'elenco" do
    visit vehicles_path

    expect(page).to have_content("Panda")
    expect(page).not_to have_content("Punto")
  end

  it "richiede conferma prima di eliminare un veicolo" do
    visit vehicles_path

    click_link href: confirm_destroy_vehicle_path(vehicle)

    expect(page).to have_content("Conferma eliminazione")
    expect(Vehicle.exists?(vehicle.id)).to be(true)

    click_button "Elimina Definitivamente"

    expect(page).to have_current_path(vehicles_path)
    expect(Vehicle.exists?(vehicle.id)).to be(false)
  end

  private

  def login_as(user)
    visit new_user_session_path
    fill_in "Nome utente", with: user.username
    fill_in "Password", with: "pAssword1234567"
    click_button "Accedi"
  end
end
