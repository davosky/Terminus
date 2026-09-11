require 'rails_helper'

RSpec.describe HolidayApproval do
  include ActiveJob::TestHelper

  it "approva la richiesta e avvisa il dipendente" do
    holiday = create(:holiday, user: create(:user, email: "dipendente@example.com"))

    expect {
      perform_enqueued_jobs { described_class.call(holiday: holiday) }
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

    expect(holiday.reload).to be_request_approved
  end

  it "è idempotente: una seconda chiamata non manda una seconda mail" do
    holiday = create(:holiday, user: create(:user, email: "dipendente@example.com"))

    expect {
      perform_enqueued_jobs do
        described_class.call(holiday: holiday)
        described_class.call(holiday: holiday)
      end
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "non approva una richiesta già respinta" do
    holiday = create(:holiday, :rejected)

    described_class.call(holiday: holiday)

    expect(holiday.reload).to be_rejected
  end
end
