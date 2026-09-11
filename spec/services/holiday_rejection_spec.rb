require 'rails_helper'

RSpec.describe HolidayRejection do
  include ActiveJob::TestHelper

  it "respinge la richiesta con il motivo e avvisa il dipendente" do
    holiday = create(:holiday, user: create(:user, email: "dipendente@example.com"))

    expect {
      perform_enqueued_jobs { described_class.call(holiday: holiday, rejection_motivation: "Chiusura di bilancio") }
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

    expect(holiday.reload).to be_rejected
    expect(holiday.rejection_motivation).to eq("Chiusura di bilancio")
  end

  it "non salva né avvisa se il motivo è vuoto" do
    holiday = create(:holiday)

    result = nil
    expect {
      perform_enqueued_jobs { result = described_class.call(holiday: holiday, rejection_motivation: "") }
    }.not_to change { ActionMailer::Base.deliveries.count }

    expect(result.errors).to be_present
    expect(holiday.reload).to be_pending
  end

  it "aggiorna in tempo reale le pagine dei direttori solo se respinge davvero" do
    org = { region: "FVG", province: "UD", institute: "CGIL Udine" }
    director = create(:user, :manager, **org)
    holiday = create(:holiday, user: create(:user, **org))

    assert_no_turbo_stream_broadcasts [ director, :holidays ] do
      described_class.call(holiday: holiday, rejection_motivation: "")
    end
    assert_turbo_stream_broadcasts [ director, :holidays ], count: 1 do
      described_class.call(holiday: holiday, rejection_motivation: "Chiusura di bilancio")
    end
  end
end
