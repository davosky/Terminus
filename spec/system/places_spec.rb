require 'rails_helper'

RSpec.describe "Places", type: :system do
  let!(:user) { create(:user, username: "mario") }
  let!(:other_user) { create(:user, username: "luigi") }
  let!(:place) { create(:place, user: user, name: "Trieste") }
  let!(:other_place) { create(:place, user: other_user, name: "Udine") }

  before { login_as(user) }

  it "mostra solo i luoghi dell'utente corrente nell'elenco" do
    visit places_path

    expect(page).to have_content("Trieste")
    expect(page).not_to have_content("Udine")
  end

  it "richiede conferma prima di eliminare un luogo" do
    visit places_path

    click_link href: confirm_destroy_place_path(place)

    expect(page).to have_content("Conferma eliminazione")
    expect(Place.exists?(place.id)).to be(true)

    click_button "Elimina Definitivamente"

    expect(page).to have_current_path(places_path)
    expect(Place.exists?(place.id)).to be(false)
  end

  private

  def login_as(user)
    visit new_user_session_path
    fill_in "Nome utente", with: user.username
    fill_in "Password", with: "pAssword1234567"
    click_button "Accedi"
  end
end
