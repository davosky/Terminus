require "rails_helper"

RSpec.describe "Admin user signature upload", type: :system do
  let!(:admin) { create(:user, :admin, username: "admin-user", password: "pAssword1234567") }
  let!(:target_user) { create(:user, username: "mario-rossi") }

  before do
    visit new_user_session_path
    fill_in "Nome utente", with: admin.username
    fill_in "Password", with: "pAssword1234567"
    click_button "Accedi"
  end

  it "mostra l'etichetta localizzata e permette il caricamento della firma utente" do
    visit edit_admin_user_path(target_user)

    expect(page).to have_content("Firma Utente")

    attach_file "user_user_signature", Rails.root.join("spec/fixtures/files/signature.png")
    click_button "Aggiorna Utente"

    target_user.reload
    expect(target_user.user_signature.file).to be_present
    expect(target_user.user_signature_url).to match(/signature\.png\z/)

    download_path = download_signature_admin_user_path(target_user)
    expect(page).to have_css("img[src='#{download_path}']")

    visit download_path
    expect(page.status_code).to eq(200)
    expect(page.response_headers["Content-Type"]).to eq("image/png")
  end

  it "mostra i campi del validatore e permette il caricamento della sua firma" do
    visit edit_admin_user_path(target_user)

    expect(page).to have_content("Validatore")
    expect(page).to have_content("Titolo Validatore")
    expect(page).to have_content("Firma Validatore")

    fill_in "user_validator", with: "Luigi Bianchi"
    fill_in "user_validator_presentation", with: "Responsabile Amministrazione"
    attach_file "user_validator_signature", Rails.root.join("spec/fixtures/files/signature.png")
    click_button "Aggiorna Utente"

    target_user.reload
    expect(target_user.validator).to eq("Luigi Bianchi")
    expect(target_user.validator_presentation).to eq("Responsabile Amministrazione")
    expect(target_user.validator_signature.file).to be_present

    download_path = download_validator_signature_admin_user_path(target_user)
    expect(page).to have_css("img[src='#{download_path}']")

    visit download_path
    expect(page.status_code).to eq(200)
    expect(page.response_headers["Content-Type"]).to eq("image/png")
  end

  it "mostra i campi del confermatore e permette il caricamento della sua firma" do
    visit edit_admin_user_path(target_user)

    expect(page).to have_content("Confermatore")
    expect(page).to have_content("Titolo Confermatore")
    expect(page).to have_content("Firma Confermatore")

    fill_in "user_confirmator", with: "Anna Verdi"
    fill_in "user_confirmator_presentation", with: "Direttore Generale"
    attach_file "user_confirmator_signature", Rails.root.join("spec/fixtures/files/signature.png")
    click_button "Aggiorna Utente"

    target_user.reload
    expect(target_user.confirmator).to eq("Anna Verdi")
    expect(target_user.confirmator_presentation).to eq("Direttore Generale")
    expect(target_user.confirmator_signature.file).to be_present

    download_path = download_confirmator_signature_admin_user_path(target_user)
    expect(page).to have_css("img[src='#{download_path}']")

    visit download_path
    expect(page.status_code).to eq(200)
    expect(page.response_headers["Content-Type"]).to eq("image/png")
  end
end
