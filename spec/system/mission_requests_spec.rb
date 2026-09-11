require 'rails_helper'

RSpec.describe "MissionRequests", type: :system do
  let!(:user) { create(:user, :mission_requesting, username: "mario", region: "FVG", province: "FVG") }
  let!(:other_user) { create(:user, username: "luigi") }
  let!(:mission_request) { create(:mission_request, user: user, name: "MR-MR-FVG-FVG-202608180925-0001") }
  let!(:other_mission_request) { create(:mission_request, user: other_user, name: "MR-LL-FVG-FVG-202608180925-0002") }

  before { sign_in(user) }

  it "mostra solo le richieste missione dell'utente corrente nell'elenco" do
    visit mission_requests_path

    expect(page).to have_link(href: mission_request_path(mission_request))
    expect(page).not_to have_link(href: mission_request_path(other_mission_request))
  end

  it "richiede conferma prima di eliminare una richiesta missione" do
    visit mission_requests_path

    click_link href: confirm_destroy_mission_request_path(mission_request)

    expect(page).to have_content("Conferma eliminazione")
    expect(MissionRequest.exists?(mission_request.id)).to be(true)

    click_button "Elimina Definitivamente"

    expect(page).to have_current_path(mission_requests_path)
    expect(MissionRequest.exists?(mission_request.id)).to be(false)
  end
end
