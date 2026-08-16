require 'rails_helper'

RSpec.describe "Navbar", type: :system do
  context "quando l'utente è amministratore" do
    let!(:admin) { create(:user, :admin, username: "admin") }

    it "mostra 'Utility', poi 'Amministrazione', poi 'Esci' allineati a destra" do
      login_as(admin)
      visit root_path

      right_nav = find("nav .navbar-nav:not(.me-auto)")
      link_labels = right_nav.all("li.nav-item").map(&:text)

      expect(link_labels.first).to include("Utility")
      expect(link_labels.second).to include("Amministrazione")
      expect(link_labels.last).to include("Esci")
    end
  end

  context "quando l'utente non è amministratore" do
    let!(:user) { create(:user, username: "regular") }

    it "non mostra il link 'Amministrazione'" do
      login_as(user)
      visit root_path

      expect(page).not_to have_link("Amministrazione")
    end

    it "mostra comunque il dropdown 'Utility' allineato a destra, prima di 'Esci'" do
      login_as(user)
      visit root_path

      right_nav = find("nav .navbar-nav:not(.me-auto)")
      link_labels = right_nav.all("li.nav-item").map(&:text)

      expect(link_labels.first).to include("Utility")
      expect(link_labels.last).to include("Esci")
    end
  end

  private

  def login_as(user)
    visit new_user_session_path
    fill_in "Nome utente", with: user.username
    fill_in "Password", with: "pAssword1234567"
    click_button "Accedi"
  end
end
