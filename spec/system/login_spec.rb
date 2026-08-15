require 'rails_helper'

RSpec.describe "Login", type: :system do
  let!(:user) { create(:user, username: "mario", password: "pAssword1234567") }

  context "quando le credenziali sono corrette" do
    it "accede e vede la dashboard" do
      visit new_user_session_path

      fill_in "Nome utente", with: "mario"
      fill_in "Password", with: "pAssword1234567"
      click_button "Accedi"

      expect(page).to have_content("Benvenuto")
    end
  end

  context "quando le credenziali sono errate" do
    it "resta sulla pagina di login con un messaggio di errore" do
      visit new_user_session_path

      fill_in "Nome utente", with: "mario"
      fill_in "Password", with: "password-sbagliata"
      click_button "Accedi"

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
