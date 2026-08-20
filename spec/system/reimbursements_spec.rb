require 'rails_helper'

RSpec.describe "Reimbursements", type: :system do
  let!(:user) { create(:user, username: "mario", region: "FVG", province: "FVG") }
  let!(:other_user) { create(:user, username: "luigi") }
  let!(:reimbursement) { create(:reimbursement, user: user, name: "RB-MR-FVG-FVG-202608180925-0001") }
  let!(:other_reimbursement) { create(:reimbursement, user: other_user, name: "RB-LL-FVG-FVG-202608180925-0002") }

  before { login_as(user) }

  it "mostra solo i rimborsi spese dell'utente corrente nell'elenco" do
    visit reimbursements_path

    expect(page).to have_link(href: reimbursement_path(reimbursement))
    expect(page).not_to have_link(href: reimbursement_path(other_reimbursement))
  end

  it "richiede conferma prima di eliminare un rimborso spese" do
    visit reimbursements_path

    click_link href: confirm_destroy_reimbursement_path(reimbursement)

    expect(page).to have_content("Conferma eliminazione")
    expect(Reimbursement.exists?(reimbursement.id)).to be(true)

    click_button "Elimina Definitivamente"

    expect(page).to have_current_path(reimbursements_path)
    expect(Reimbursement.exists?(reimbursement.id)).to be(false)
  end

  private

  def login_as(user)
    visit new_user_session_path
    fill_in "Nome utente", with: user.username
    fill_in "Password", with: "pAssword1234567"
    click_button "Accedi"
  end
end
