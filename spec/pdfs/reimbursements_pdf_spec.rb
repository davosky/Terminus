require "rails_helper"

RSpec.describe ReimbursementsPdf do
  def page_count(pdf_string)
    pdf_string.scan("/Type /Page\n").size
  end

  it "genera un PDF valido con una pagina per rimborso spese" do
    reimbursements = create_list(:reimbursement, 3)

    pdf_string = described_class.new(reimbursements).render

    expect(pdf_string).to start_with("%PDF")
    expect(page_count(pdf_string)).to eq(3)
  end

  it "rende il pannello del mezzo quando il rimborso spese ha un veicolo privato" do
    private_transport = create(:transport, name: ReimbursementTotalCalculator::PRIVATE_VEHICLE_NAME)
    vehicle = create(:vehicle, cost_per_km: 0.42)
    reimbursement = create(:reimbursement, transport: private_transport, vehicle: vehicle)

    pdf_string = nil
    expect { pdf_string = described_class.new([ reimbursement ]).render }.not_to raise_error
    expect(page_count(pdf_string)).to eq(1)
  end

  it "rende i campi in modalità testo libero" do
    reimbursement = create(:reimbursement, :free_fields)

    pdf_string = nil
    expect { pdf_string = described_class.new([ reimbursement ]).render }.not_to raise_error
    expect(pdf_string).to start_with("%PDF")
  end

  context "quando l'utente ha caricato le firme" do
    let(:signature) { Rails.root.join("spec/fixtures/files/signature.png").open }

    after { signature.close }

    it "incorpora le immagini delle firme senza errori" do
      user = create(:user)
      user.update!(
        user_signature: signature,
        validator_signature: signature,
        confirmator_signature: signature
      )
      reimbursement = create(:reimbursement, user: user)

      pdf_string = nil
      expect { pdf_string = described_class.new([ reimbursement ]).render }.not_to raise_error
      expect(pdf_string).to start_with("%PDF")
    end
  end
end
