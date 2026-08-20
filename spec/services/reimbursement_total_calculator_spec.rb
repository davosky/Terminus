require 'rails_helper'

RSpec.describe ReimbursementTotalCalculator do
  let(:common_costs) { { parking_cost: 5, food_cost: 30, room_cost: 80, ticket_cost: 2, generic_cost: 1 } }

  describe "trasporto Veicolo Privato" do
    let(:transport) { create(:transport, name: "Veicolo Privato") }
    let(:vehicle) { create(:vehicle, cost_per_km: 0.5) }

    it "somma il costo chilometrico del percorso memorizzato, l'autostrada, il parcheggio e le spese di soggiorno" do
      path = create(:path, lenght: 100, highway_cost: 10)
      reimbursement = build(:reimbursement, **common_costs, transport: transport, vehicle: vehicle, path: path, reason: nil, place: nil, structure: nil)

      expect(described_class.call(reimbursement: reimbursement)).to eq(100 * 0.5 + 10 + 5 + 30 + 80 + 2 + 1)
    end

    it "usa i campi liberi quando il percorso non è memorizzato" do
      reimbursement = build(:reimbursement, :free_fields, **common_costs, transport: transport, vehicle: vehicle, path_lenght_fr: 40, highway_cost_fr: 3)

      expect(described_class.call(reimbursement: reimbursement)).to eq(40 * 0.5 + 3 + 5 + 30 + 80 + 2 + 1)
    end
  end

  describe "trasporto Veicolo Aziendale" do
    let(:transport) { create(:transport, name: "Veicolo Aziendale") }

    it "somma solo l'autostrada, il parcheggio e le spese di soggiorno, senza costo chilometrico" do
      path = create(:path, lenght: 100, highway_cost: 10)
      reimbursement = build(:reimbursement, **common_costs, transport: transport, vehicle: nil, path: path, reason: nil, place: nil, structure: nil)

      expect(described_class.call(reimbursement: reimbursement)).to eq(10 + 5 + 30 + 80 + 2 + 1)
    end
  end

  describe "altri trasporti" do
    let(:transport) { create(:transport, name: "Treno") }

    it "somma solo le spese di soggiorno, senza autostrada né parcheggio" do
      path = create(:path, lenght: 100, highway_cost: 10)
      reimbursement = build(:reimbursement, **common_costs, transport: transport, vehicle: nil, path: path, reason: nil, place: nil, structure: nil)

      expect(described_class.call(reimbursement: reimbursement)).to eq(30 + 80 + 2 + 1)
    end
  end
end
