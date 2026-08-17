require 'rails_helper'

RSpec.describe "Transports", type: :system do
  let!(:user) { create(:user, username: "mario") }
  let!(:other_user) { create(:user, username: "luigi") }
  let!(:transport) { create(:transport, user: user, name: "Auto") }
  let!(:other_transport) { create(:transport, user: other_user, name: "Treno") }

  before { login_as(user) }

  it "mostra solo i trasporti dell'utente corrente nell'elenco" do
    visit transports_path

    expect(page).to have_content("Auto")
    expect(page).not_to have_content("Treno")
  end

  it "richiede conferma prima di eliminare un trasporto" do
    visit transports_path

    click_link href: confirm_destroy_transport_path(transport)

    expect(page).to have_content("Conferma eliminazione")
    expect(Transport.exists?(transport.id)).to be(true)

    click_button "Elimina Definitivamente"

    expect(page).to have_current_path(transports_path)
    expect(Transport.exists?(transport.id)).to be(false)
  end

  it "impedisce l'eliminazione di un record di sistema" do
    protected_transport = create(:transport, user: user, name: "Veicolo Aziendale")

    visit transports_path
    click_link href: confirm_destroy_transport_path(protected_transport)

    expect(page).to have_content("Attenzione")
    expect(page).to have_content("Record di Sistema - Questo record non può essere eliminato")
    expect(page).not_to have_button("Elimina Definitivamente")
    expect(Transport.exists?(protected_transport.id)).to be(true)
  end

  it "impedisce la modifica di un record di sistema" do
    protected_transport = create(:transport, user: user, name: "Veicolo Privato")

    visit transports_path
    click_link href: edit_transport_path(protected_transport)

    expect(page).to have_content("Attenzione")
    expect(page).to have_content("Record di Sistema - Questo record non può essere modificato")
    expect(page).not_to have_field("Trasporto")
    expect(protected_transport.reload.name).to eq("Veicolo Privato")
  end

  private

  def login_as(user)
    visit new_user_session_path
    fill_in "Nome utente", with: user.username
    fill_in "Password", with: "pAssword1234567"
    click_button "Accedi"
  end
end
