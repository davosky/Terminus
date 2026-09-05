require 'rails_helper'

RSpec.describe "Reimbursements", type: :request do
  let!(:user) { create(:user, region: "FVG", province: "FVG") }
  let!(:other_user) { create(:user) }
  let!(:reimbursement) { create(:reimbursement, user: user) }
  let!(:other_reimbursement) { create(:reimbursement, user: other_user) }

  before { sign_in user }

  describe "GET /reimbursements" do
    it "mostra solo i rimborsi spese dell'utente corrente" do
      get reimbursements_path

      expect(response.body).to include(reimbursement_path(reimbursement))
      expect(response.body).not_to include(reimbursement_path(other_reimbursement))
    end
  end

  describe "GET /reimbursements/:id" do
    it "consente di vedere un proprio rimborso spese" do
      get reimbursement_path(reimbursement)

      expect(response).to have_http_status(:ok)
    end

    it "impedisce di vedere il rimborso spese di un altro utente" do
      get reimbursement_path(other_reimbursement)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /reimbursements" do
    let(:reason) { create(:reason, user: user) }
    let(:place) { create(:place, user: user) }
    let(:structure) { create(:structure, user: user) }
    let(:path) { create(:path, user: user) }
    let(:transport) { create(:transport, user: user) }

    it "crea un rimborso spese con i modelli memorizzati assegnato all'utente corrente" do
      expect {
        post reimbursements_path, params: {
          reimbursement: {
            departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
            reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
            transport_id: transport.id
          }
        }
      }.to change(user.reimbursements, :count).by(1)
    end

    it "genera automaticamente il codice del rimborso" do
      post reimbursements_path, params: {
        reimbursement: {
          departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
          reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
          transport_id: transport.id
        }
      }

      expect(user.reimbursements.last.name).to match(/\ARB-/)
    end

    it "valorizza automaticamente la data di rimborso se non indicata" do
      post reimbursements_path, params: {
        reimbursement: {
          departure_date: Date.new(2026, 8, 18), return_date: Date.new(2026, 8, 20), request_date: Date.current,
          reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
          transport_id: transport.id
        }
      }

      expect(user.reimbursements.last.reimbursement_date).to eq(Date.new(2026, 8, 28))
    end

    it "non sovrascrive la data di rimborso se indicata esplicitamente" do
      post reimbursements_path, params: {
        reimbursement: {
          departure_date: Date.new(2026, 8, 18), return_date: Date.new(2026, 8, 20), request_date: Date.current,
          reimbursement_date: Date.new(2026, 8, 15),
          reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
          transport_id: transport.id
        }
      }

      expect(user.reimbursements.last.reimbursement_date).to eq(Date.new(2026, 8, 15))
    end

    it "calcola automaticamente il totale in base al trasporto selezionato" do
      post reimbursements_path, params: {
        reimbursement: {
          departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
          reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
          transport_id: transport.id,
          food_cost: 30, room_cost: 80, ticket_cost: 2, generic_cost: 1, parking_cost: 5
        }
      }

      expect(user.reimbursements.last.total_amount).to eq(30 + 80 + 2 + 1)
    end

    it "include il costo chilometrico quando il trasporto è Veicolo Privato" do
      private_vehicle_transport = create(:transport, user: user, name: "Veicolo Privato")
      vehicle = create(:vehicle, user: user, cost_per_km: 0.5)

      post reimbursements_path, params: {
        reimbursement: {
          departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
          reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
          transport_id: private_vehicle_transport.id, vehicle_id: vehicle.id,
          food_cost: 30, room_cost: 80, ticket_cost: 2, generic_cost: 1, parking_cost: 5
        }
      }

      expect(user.reimbursements.last.total_amount).to eq((path.lenght * 0.5) + path.highway_cost + 5 + 30 + 80 + 2 + 1)
    end

    it "ignora un totale inviato manualmente e lo ricalcola" do
      post reimbursements_path, params: {
        reimbursement: {
          departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
          reason_id: reason.id, place_id: place.id, structure_id: structure.id, path_id: path.id,
          transport_id: transport.id, total_amount: 999,
          food_cost: 30, room_cost: 80, ticket_cost: 2, generic_cost: 1
        }
      }

      expect(user.reimbursements.last.total_amount).to eq(30 + 80 + 2 + 1)
    end

    it "crea un rimborso spese con i campi liberi" do
      expect {
        post reimbursements_path, params: {
          reimbursement: {
            departure_date: Date.current, return_date: Date.current + 2.days, request_date: Date.current,
            reason_fr: "Corso", place_fr: "Udine", structure_fr: "Sede regionale", path_fr: "Trieste-Udine",
            path_lenght_fr: 68.5, highway_cost_fr: 4.5, transport_id: transport.id
          }
        }
      }.to change(user.reimbursements, :count).by(1)
    end
  end

  describe "quando l'utente corrente è amministratore" do
    let!(:admin) { create(:user, :admin) }
    let!(:admin_reimbursement) { create(:reimbursement, user: admin) }

    before { sign_in admin }

    it "elenca solo i propri rimborsi spese" do
      get reimbursements_path

      expect(response.body).to include(reimbursement_path(admin_reimbursement))
      expect(response.body).not_to include(reimbursement_path(reimbursement))
    end

    it "non consente di vedere il rimborso spese di un altro utente" do
      get reimbursement_path(reimbursement)

      expect(response).to have_http_status(:not_found)
    end

    it "non consente di modificare il rimborso spese di un altro utente" do
      patch reimbursement_path(reimbursement), params: { reimbursement: { food_cost: 99 } }

      expect(response).to have_http_status(:not_found)
      expect(reimbursement.reload.food_cost).not_to eq(99)
    end

    it "non consente di eliminare il rimborso spese di un altro utente" do
      expect {
        delete reimbursement_path(reimbursement)
      }.not_to change(Reimbursement, :count)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /reimbursements/:id/edit" do
    it "nasconde la scelta della modalità di inserimento e mostra i campi memorizzati" do
      get edit_reimbursement_path(reimbursement)

      page = Nokogiri::HTML(response.body)
      expect(page.at_css("#input_mode_stored")).to be_nil
      expect(page.at_css('[data-reimbursement-mode-target="stored"]')["class"]).not_to include("d-none")
      expect(page.at_css('[data-reimbursement-mode-target="free"]')["class"]).to include("d-none")
    end

    it "mostra i campi liberi quando il rimborso è stato creato in quella modalità" do
      free_reimbursement = create(:reimbursement, :free_fields, user: user)

      get edit_reimbursement_path(free_reimbursement)

      page = Nokogiri::HTML(response.body)
      expect(page.at_css("#input_mode_stored")).to be_nil
      expect(page.at_css('[data-reimbursement-mode-target="free"]')["class"]).not_to include("d-none")
      expect(page.at_css('[data-reimbursement-mode-target="stored"]')["class"]).to include("d-none")
    end
  end

  describe "PATCH /reimbursements/:id" do
    it "aggiorna un proprio rimborso spese" do
      patch reimbursement_path(reimbursement), params: { reimbursement: { departure_date: Date.current + 1.day } }

      expect(reimbursement.reload.departure_date).to eq(Date.current + 1.day)
    end

    it "ricalcola il totale quando cambiano i costi" do
      patch reimbursement_path(reimbursement), params: { reimbursement: { food_cost: 40, room_cost: 60 } }

      expect(reimbursement.reload.total_amount).to eq(40 + 60)
    end
  end

  describe "PATCH /reimbursements/:id per un rimborso generato da un'approvazione" do
    let(:mission_request) { create(:mission_request, user: user) }
    let!(:generated) { create(:reimbursement, user: user, mission_request: mission_request) }

    it "la pagina di modifica mostra solo la data rimborso e i cinque campi spesa" do
      get edit_reimbursement_path(generated)

      page = Nokogiri::HTML(response.body)
      expect(page.at_css("input[name='reimbursement[reimbursement_date]']")).to be_present
      expect(page.at_css("input[name='reimbursement[generic_cost]']")).to be_present
      expect(page.at_css("input[name='reimbursement[departure_date]']")).to be_nil
      expect(page.at_css("select[name='reimbursement[transport_id]']")).to be_nil
      expect(response.body).to include("generato dall'approvazione")
    end

    it "aggiorna la data rimborso e i cinque campi spesa consentiti e ricalcola il totale" do
      patch reimbursement_path(generated), params: {
        reimbursement: {
          reimbursement_date: Date.current + 10.days,
          parking_cost: 5, food_cost: 40, room_cost: 60, ticket_cost: 3, generic_cost: 2
        }
      }

      generated.reload
      expect(generated.reimbursement_date).to eq(Date.current + 10.days)
      expect([ generated.parking_cost, generated.food_cost, generated.room_cost, generated.ticket_cost, generated.generic_cost ])
        .to eq([ 5, 40, 60, 3, 2 ])
      # Il trasporto della factory non è "Veicolo Privato"/"Aziendale", quindi il
      # parcheggio è escluso dal calcolo (vedi ReimbursementTotalCalculator).
      expect(generated.total_amount).to eq(40 + 60 + 3 + 2)
    end

    it "ignora ogni altro campo inviato a mano (dev tools, console, curl)" do
      original_departure = generated.departure_date
      original_reason_id = generated.reason_id
      original_transport_id = generated.transport_id
      other_transport = create(:transport, user: user)

      patch reimbursement_path(generated), params: {
        reimbursement: {
          food_cost: 10,
          departure_date: Date.current + 30.days,
          reason_id: "",
          reason_fr: "Iniettato",
          transport_id: other_transport.id,
          mission_request_id: ""
        }
      }

      generated.reload
      expect(generated.food_cost).to eq(10)
      expect(generated.departure_date).to eq(original_departure)
      expect(generated.reason_id).to eq(original_reason_id)
      expect(generated.reason_fr).to be_nil
      expect(generated.transport_id).to eq(original_transport_id)
      expect(generated).to be_from_mission_request
    end
  end

  describe "il direttore (manager) non ha alcun accesso privilegiato ai rimborsi" do
    let(:director) { create(:user, :manager, region: "FVG", province: "FVG") }

    before { sign_in director }

    it "in elenco vede solo i propri rimborsi, non quelli dei dipendenti" do
      get reimbursements_path

      expect(response.body).not_to include(reimbursement_path(reimbursement))
      expect(response.body).not_to include(reimbursement_path(other_reimbursement))
    end

    it "non può aprire il rimborso di un altro utente" do
      get reimbursement_path(reimbursement)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /reimbursements/:id/confirm_destroy" do
    it "mostra la pagina di conferma senza eliminare il record" do
      expect {
        get confirm_destroy_reimbursement_path(reimbursement)
      }.not_to change(Reimbursement, :count)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /reimbursements/:id" do
    it "elimina un proprio rimborso spese" do
      expect {
        delete reimbursement_path(reimbursement)
      }.to change(Reimbursement, :count).by(-1)
    end

    it "impedisce di eliminare il rimborso spese di un altro utente" do
      expect {
        delete reimbursement_path(other_reimbursement)
      }.not_to change(Reimbursement, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
