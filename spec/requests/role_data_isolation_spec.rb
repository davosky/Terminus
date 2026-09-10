require 'rails_helper'

RSpec.describe "Isolamento dei dati per ruolo", type: :request do
  # Ogni risorsa con l'attributo che la rende riconoscibile nella pagina indice.
  resources = {
    vehicle: :licence_plate,
    transport: :name,
    reason: :name,
    path: :name,
    place: :name,
    structure: :name
  }

  %i[admin manager payroll].each do |role|
    context "quando l'utente ha il ruolo #{role}" do
      let!(:privileged) { create(:user, role) }
      let!(:other_user) { create(:user) }

      before { sign_in privileged }

      resources.each do |factory, attribute|
        describe "GET /#{factory}s" do
          let!(:own) { create(factory, user: privileged) }
          let!(:other) { create(factory, user: other_user) }

          it "elenca solo i propri record" do
            get send("#{factory}s_path")

            expect(response.body).to include(own.public_send(attribute))
            expect(response.body).not_to include(other.public_send(attribute))
          end

          it "nega l'accesso al record di un altro utente" do
            get send("#{factory}_path", other)

            expect(response).to have_http_status(:not_found)
          end

          it "impedisce di eliminare il record di un altro utente" do
            expect {
              delete send("#{factory}_path", other)
            }.not_to change(factory.to_s.camelize.constantize, :count)

            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
  end

  describe "rimborsi spese" do
    let!(:other_user) { create(:user) }
    let!(:other_reimbursement) { create(:reimbursement, user: other_user) }

    %i[admin manager payroll].each do |role|
      context "quando l'utente ha il ruolo #{role}" do
        let!(:privileged) { create(:user, role) }
        let!(:own) { create(:reimbursement, user: privileged) }

        before { sign_in privileged }

        it "elenca solo i propri rimborsi" do
          get reimbursements_path

          expect(response.body).to include(reimbursement_path(own))
          expect(response.body).not_to include(reimbursement_path(other_reimbursement))
        end

        it "nega l'accesso al rimborso di un altro utente" do
          get reimbursement_path(other_reimbursement)

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "flag Richiede Missione" do
    let!(:without_flag) { create(:user) }
    let!(:own) { create(:mission_request, user: without_flag) }

    before { sign_in without_flag }

    it "nega l'elenco delle richieste missione" do
      get mission_requests_path

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Non sei autorizzato a eseguire questa azione.")
    end

    it "nega il modulo di creazione" do
      get new_mission_request_path

      expect(response).to redirect_to(root_path)
    end

    it "impedisce di creare una richiesta missione" do
      expect {
        post mission_requests_path, params: { mission_request: attributes_for(:mission_request) }
      }.not_to change(MissionRequest, :count)
    end

    it "nega l'accesso a una propria richiesta preesistente" do
      get mission_request_path(own)

      expect(response).to have_http_status(:not_found)
    end

    it "consente tutto allo stesso utente una volta attivato il flag" do
      without_flag.update!(mission_requesting_user: true)

      get mission_requests_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(mission_request_path(own))
    end
  end

  describe "richieste missione" do
    let!(:other_user) { create(:user, :mission_requesting) }
    let!(:other_mission_request) { create(:mission_request, user: other_user) }

    %i[admin payroll].each do |role|
      context "quando l'utente ha il ruolo #{role}" do
        let!(:privileged) { create(:user, role, :mission_requesting) }
        let!(:own) { create(:mission_request, user: privileged) }

        before { sign_in privileged }

        it "elenca solo le proprie richieste" do
          get mission_requests_path

          expect(response.body).to include(mission_request_path(own))
          expect(response.body).not_to include(mission_request_path(other_mission_request))
        end

        it "nega l'accesso alla richiesta di un altro utente" do
          get mission_request_path(other_mission_request)

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
