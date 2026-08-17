require 'rails_helper'

RSpec.describe "Reasons", type: :system do
  let!(:user) { create(:user, username: "mario") }
  let!(:other_user) { create(:user, username: "luigi") }
  let!(:reason) { create(:reason, user: user, name: "Trasferta cliente") }
  let!(:other_reason) { create(:reason, user: other_user, name: "Formazione") }

  before { login_as(user) }

  it "mostra solo i motivi missione dell'utente corrente nell'elenco" do
    visit reasons_path

    expect(page).to have_content("Trasferta cliente")
    expect(page).not_to have_content("Formazione")
  end

  it "richiede conferma prima di eliminare un motivo missione" do
    visit reasons_path

    click_link href: confirm_destroy_reason_path(reason)

    expect(page).to have_content("Conferma eliminazione")
    expect(Reason.exists?(reason.id)).to be(true)

    click_button "Elimina Definitivamente"

    expect(page).to have_current_path(reasons_path)
    expect(Reason.exists?(reason.id)).to be(false)
  end

  private

  def login_as(user)
    visit new_user_session_path
    fill_in "Nome utente", with: user.username
    fill_in "Password", with: "pAssword1234567"
    click_button "Accedi"
  end
end
