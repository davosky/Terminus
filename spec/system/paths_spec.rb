require 'rails_helper'

RSpec.describe "Paths", type: :system do
  let!(:user) { create(:user, username: "mario") }
  let!(:other_user) { create(:user, username: "luigi") }
  let!(:path) { create(:path, user: user, name: "Trieste-Udine") }
  let!(:other_path) { create(:path, user: other_user, name: "Pordenone-Gorizia") }

  before { sign_in(user) }

  it "mostra solo i percorsi dell'utente corrente nell'elenco" do
    visit paths_path

    expect(page).to have_content("Trieste-Udine")
    expect(page).not_to have_content("Pordenone-Gorizia")
  end

  it "richiede conferma prima di eliminare un percorso" do
    visit paths_path

    click_link href: confirm_destroy_path_path(path)

    expect(page).to have_content("Conferma eliminazione")
    expect(Path.exists?(path.id)).to be(true)

    click_button "Elimina Definitivamente"

    expect(page).to have_current_path(paths_path)
    expect(Path.exists?(path.id)).to be(false)
  end
end
