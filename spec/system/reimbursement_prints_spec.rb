require 'rails_helper'

RSpec.describe "Reimbursement prints", type: :system do
  let!(:user) { create(:user, username: "mario", region: "FVG", province: "FVG") }
  let!(:june_reimbursement) do
    create(:reimbursement, user: user, name: "RB-MR-FVG-FVG-202606200925-0001", departure_date: Date.new(2026, 6, 20))
  end
  let!(:july_reimbursement) do
    create(:reimbursement, user: user, name: "RB-MR-FVG-FVG-202607100925-0002", departure_date: Date.new(2026, 7, 10))
  end

  before { login_as(user) }

  it "raggiunge la pagina di stampa dal menu 'Rimborsi Spese'" do
    visit root_path

    within("nav .navbar-nav.me-auto") do
      find("#reimbursementsDropdown").click

      expect(page).to have_link("Stampa Rimborsi Spese", href: print_reimbursements_path)
    end
  end

  it "filtra i rimborsi spese per intervallo di date di partenza" do
    visit print_reimbursements_path

    fill_in "Data Partenza Da", with: "2026-06-01"
    fill_in "Data Partenza A", with: "2026-06-30"
    click_button "Cerca"

    expect(page).to have_content(june_reimbursement.display_place)
    expect(page).not_to have_content(july_reimbursement.display_place)
  end

  it "espone il bottone di generazione del PDF sui rimborsi spese filtrati" do
    visit print_reimbursements_path(q: { departure_date_gteq: "2026-06-01", departure_date_lteq: "2026-06-30" })

    expect(page).to have_link("Genera PDF",
      href: print_reimbursements_path(format: :pdf, q: { departure_date_gteq: "2026-06-01", departure_date_lteq: "2026-06-30" }))
  end

  private

  def login_as(user)
    visit new_user_session_path
    fill_in "Nome utente", with: user.username
    fill_in "Password", with: "pAssword1234567"
    click_button "Accedi"
  end
end
