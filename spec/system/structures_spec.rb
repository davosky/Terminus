require 'rails_helper'

RSpec.describe "Structures", type: :system do
  let!(:user) { create(:user, username: "mario") }
  let!(:other_user) { create(:user, username: "luigi") }
  let!(:structure) { create(:structure, user: user, name: "Sede Trieste") }
  let!(:other_structure) { create(:structure, user: other_user, name: "Sede Udine") }

  before { sign_in(user) }

  it "mostra solo le strutture dell'utente corrente nell'elenco" do
    visit structures_path

    expect(page).to have_content("Sede Trieste")
    expect(page).not_to have_content("Sede Udine")
  end

  it "richiede conferma prima di eliminare una struttura" do
    visit structures_path

    click_link href: confirm_destroy_structure_path(structure)

    expect(page).to have_content("Conferma eliminazione")
    expect(Structure.exists?(structure.id)).to be(true)

    click_button "Elimina Definitivamente"

    expect(page).to have_current_path(structures_path)
    expect(Structure.exists?(structure.id)).to be(false)
  end
end
