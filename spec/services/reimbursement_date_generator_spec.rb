require 'rails_helper'

RSpec.describe ReimbursementDateGenerator do
  it "restituisce l'ultimo venerdì del mese della data di partenza" do
    date = described_class.call(departure_date: Date.new(2026, 8, 18))

    expect(date).to eq(Date.new(2026, 8, 28))
    expect(date.friday?).to be true
  end

  it "restituisce l'ultimo giorno del mese se coincide già con un venerdì" do
    date = described_class.call(departure_date: Date.new(2026, 5, 10))

    expect(date).to eq(Date.new(2026, 5, 29))
    expect(date.friday?).to be true
  end

  it "restituisce nil se non è presente una data di partenza" do
    expect(described_class.call(departure_date: nil)).to be_nil
  end
end
