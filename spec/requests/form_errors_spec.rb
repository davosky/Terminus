require 'rails_helper'

# Con Turbo Drive un form reinviato mostra gli errori solo se la risposta è
# 422: con un 200 l'utente resterebbe sul form vecchio senza alcun messaggio.
RSpec.describe "Errori di validazione dei form", type: :request do
  let(:user) { create(:user, :mission_requesting, region: "FVG", province: "UD", institute: "CGIL") }

  before { sign_in user }

  {
    vehicle: { name: "" },
    path: { name: "" },
    place: { name: "" },
    reason: { name: "" },
    structure: { name: "" },
    transport: { name: "" },
    reimbursement: { departure_date: "" },
    mission_request: { departure_date: "" },
    holiday: { start_date: "" }
  }.each do |resource, invalid_params|
    context "per #{resource}" do
      let!(:record) { create(resource, user: user) }
      let(:model) { resource.to_s.classify.constantize }
      let(:attribute) { invalid_params.keys.first }

      it "mostra il form di creazione" do
        get public_send("new_#{resource}_path")

        expect(response).to have_http_status(:ok)
      end

      it "risponde 422 a una creazione non valida senza salvare nulla" do
        expect {
          post public_send("#{resource.to_s.pluralize}_path"), params: { resource => invalid_params }
        }.not_to change(model, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "risponde 422 a una modifica non valida senza cambiare il record" do
        patch public_send("#{resource}_path", record), params: { resource => invalid_params }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(record.reload.public_send(attribute)).to be_present
      end
    end
  end
end
