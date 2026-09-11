require 'rails_helper'

RSpec.describe "Navbar", type: :system do
  context "quando l'utente è amministratore" do
    let!(:admin) { create(:user, :admin, username: "admin") }

    it "mostra 'Utility', poi 'Amministrazione', poi 'Esci' allineati a destra" do
      sign_in(admin)
      visit root_path

      right_nav = find("nav .navbar-nav:not(.me-auto)")
      link_labels = right_nav.all("li.nav-item").map(&:text)

      expect(link_labels.first).to include("Utility")
      expect(link_labels.second).to include("Amministrazione")
      expect(link_labels.last).to include("Esci")
    end
  end

  context "quando l'utente è direttore (manager)" do
    let!(:manager) { create(:user, :manager, username: "direttore", mission_requesting_user: true) }

    it "sostituisce il link 'Richieste Missione' con un dropdown di quattro voci" do
      sign_in(manager)
      visit root_path

      within("nav .navbar-nav.me-auto") do
        find("#missionRequestsDropdown").click

        expect(page).to have_link("Le Mie Richieste Missione", href: mission_requests_path)
        expect(page).to have_link("Richieste Missione Da Approvare", href: pending_director_mission_requests_path)
        expect(page).to have_link("Richieste Missione Approvate", href: approved_director_mission_requests_path)
        expect(page).to have_link("Richieste Missione Respinte", href: rejected_director_mission_requests_path)
      end
    end
  end

  context "quando l'utente non ha il flag Richiede Missione" do
    let!(:user) { create(:user, username: "senza-missioni") }
    let!(:manager) { create(:user, :manager, username: "direttore-senza-missioni") }

    it "non mostra la voce 'Richieste Missione'" do
      sign_in(user)
      visit root_path

      expect(page).not_to have_link("Richieste Missione")
    end

    it "lascia al direttore il dropdown senza la voce personale" do
      sign_in(manager)
      visit root_path

      within("nav .navbar-nav.me-auto") do
        find("#missionRequestsDropdown").click

        expect(page).not_to have_link("Le Mie Richieste Missione")
        expect(page).to have_link("Richieste Missione Da Approvare", href: pending_director_mission_requests_path)
      end
    end
  end

  context "quando l'utente non è amministratore" do
    let!(:user) { create(:user, username: "regular") }

    it "non mostra il link 'Amministrazione'" do
      sign_in(user)
      visit root_path

      expect(page).not_to have_link("Amministrazione")
    end

    it "mostra comunque il dropdown 'Utility' allineato a destra, prima di 'Esci'" do
      sign_in(user)
      visit root_path

      right_nav = find("nav .navbar-nav:not(.me-auto)")
      link_labels = right_nav.all("li.nav-item").map(&:text)

      expect(link_labels.first).to include("Utility")
      expect(link_labels.last).to include("Esci")
    end
  end

  context "voce Ferie" do
    it "è un semplice link per chi non deve richiederle e non è direttore" do
      sign_in(create(:user, username: "ferie-semplice"))
      visit root_path

      expect(page).to have_link("Ferie", href: holidays_path)
      expect(page).not_to have_link("Le Mie Richieste Ferie")
      expect(page).not_to have_link("Ferie Da Approvare")
    end

    it "offre calendario e richieste a chi deve richiedere le ferie" do
      sign_in(create(:user, :holiday_requesting, username: "ferie-richiedente"))
      visit root_path

      expect(page).to have_link("Calendario Ferie", href: holidays_path)
      expect(page).to have_link("Le Mie Richieste Ferie", href: requests_holidays_path)
      expect(page).not_to have_link("Ferie Da Approvare")
    end

    it "offre al direttore calendario e ferie da approvare" do
      sign_in(create(:user, :manager, username: "ferie-direttore"))
      visit root_path

      expect(page).to have_link("Calendario Ferie", href: holidays_path)
      expect(page).to have_link("Ferie Da Approvare", href: director_holidays_path)
    end
  end
end
