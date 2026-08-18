require 'rails_helper'

RSpec.describe MissionRequestCodeGenerator do
  let(:user) { create(:user, first_name: "Davo", last_name: "Davosky", region: "FVG", province: "FVG") }

  it "genera un codice nel formato atteso" do
    code = described_class.call(user: user)

    expect(code).to match(/\AMR-DD-FVG-FVG-\d{12}-\d{4}\z/)
  end

  it "incrementa il numero progressivo in base alle richieste esistenti" do
    create(:mission_request)

    code = described_class.call(user: user)

    expect(code).to end_with(format("%04d", MissionRequest.count + 1))
  end
end
