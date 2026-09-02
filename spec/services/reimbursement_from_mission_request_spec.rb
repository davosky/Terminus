require 'rails_helper'

RSpec.describe ReimbursementFromMissionRequest do
  it "crea un rimborso spese copiando i dati dai modelli memorizzati" do
    mission_request = create(:mission_request)

    reimbursement = described_class.call(mission_request: mission_request)

    expect(reimbursement).to be_persisted
    expect(reimbursement.user).to eq(mission_request.user)
    expect(reimbursement.departure_date).to eq(mission_request.departure_date)
    expect(reimbursement.return_date).to eq(mission_request.return_date)
    expect(reimbursement.request_date).to eq(mission_request.request_date)
    expect(reimbursement.transport).to eq(mission_request.transport)
    expect(reimbursement.reason).to eq(mission_request.reason)
    expect(reimbursement.place).to eq(mission_request.place)
    expect(reimbursement.structure).to eq(mission_request.structure)
    expect(reimbursement.path).to eq(mission_request.path)
    expect(reimbursement.name).to be_present
    expect(reimbursement.reimbursement_date).to be_present
  end

  it "collega il rimborso alla richiesta missione di origine" do
    mission_request = create(:mission_request)

    reimbursement = described_class.call(mission_request: mission_request)

    expect(reimbursement.mission_request).to eq(mission_request)
    expect(reimbursement).to be_from_mission_request
  end

  it "crea un rimborso spese copiando i campi liberi" do
    mission_request = create(:mission_request, :free_fields)

    reimbursement = described_class.call(mission_request: mission_request)

    expect(reimbursement.reason_fr).to eq(mission_request.reason_fr)
    expect(reimbursement.place_fr).to eq(mission_request.place_fr)
    expect(reimbursement.structure_fr).to eq(mission_request.structure_fr)
    expect(reimbursement.path_fr).to eq(mission_request.path_fr)
    expect(reimbursement.path_lenght_fr).to eq(mission_request.path_lenght_fr)
    expect(reimbursement.highway_cost_fr).to eq(mission_request.highway_cost_fr)
  end
end
