require 'rails_helper'

RSpec.describe "Reimbursement prints", type: :request do
  let!(:user) { create(:user, institute: "CGIL Friuli Venezia Giulia") }
  let!(:other_user) { create(:user) }
  let!(:june_reimbursement) { create(:reimbursement, user: user, departure_date: Date.new(2026, 6, 20)) }
  let!(:july_reimbursement) { create(:reimbursement, user: user, departure_date: Date.new(2026, 7, 10)) }
  let!(:other_reimbursement) { create(:reimbursement, user: other_user, departure_date: Date.new(2026, 6, 21)) }

  before { sign_in user }

  describe "GET /reimbursements/print" do
    it "mostra la pagina di stampa con il modulo di ricerca" do
      get print_reimbursements_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("q[departure_date_gteq]")
      expect(response.body).to include("q[departure_date_lteq]")
    end

    it "filtra i rimborsi spese per intervallo di date di partenza" do
      get print_reimbursements_path, params: { q: { departure_date_gteq: "2026-06-01", departure_date_lteq: "2026-06-30" } }

      expect(response.body).to include(june_reimbursement.display_place)
      expect(response.body).not_to include(july_reimbursement.display_place)
    end

    it "esclude i rimborsi spese di un altro utente" do
      get print_reimbursements_path, params: { q: { departure_date_gteq: "2026-06-01", departure_date_lteq: "2026-06-30" } }

      expect(response.body).not_to include(other_reimbursement.display_place)
    end

    it "ignora i parametri di ricerca non consentiti" do
      get print_reimbursements_path, params: { q: { user_id_eq: other_user.id } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(june_reimbursement.display_place)
    end
  end

  describe "GET /reimbursements/print per un amministratore" do
    let!(:admin) { create(:user, :admin) }
    let!(:admin_reimbursement) { create(:reimbursement, user: admin, departure_date: Date.new(2026, 6, 22)) }

    before { sign_in admin }

    it "elenca solo i propri rimborsi spese" do
      get print_reimbursements_path

      expect(response.body).to include(admin_reimbursement.display_place)
      expect(response.body).not_to include(june_reimbursement.display_place)
    end

    it "stampa un PDF con la sola pagina del proprio rimborso spese" do
      get print_reimbursements_path(format: :pdf)

      expect(response.media_type).to eq("application/pdf")
      expect(response.body.scan("/Type /Page\n").size).to eq(1)
    end
  end

  describe "GET /reimbursements/print.pdf" do
    it "genera un PDF con una pagina per rimborso spese" do
      get print_reimbursements_path(format: :pdf)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/pdf")
      expect(response.body).to start_with("%PDF")
      expect(response.body.scan("/Type /Page\n").size).to eq(2)
    end

    it "rimanda alla pagina di stampa quando il periodo non contiene rimborsi spese" do
      get print_reimbursements_path(format: :pdf, q: { departure_date_gteq: "2020-01-01", departure_date_lteq: "2020-12-31" })

      expect(response).to redirect_to(print_reimbursements_path(q: { departure_date_gteq: "2020-01-01", departure_date_lteq: "2020-12-31" }))
      expect(flash[:alert]).to eq("Nessun rimborso spese da stampare per il periodo selezionato.")
    end
  end
end
