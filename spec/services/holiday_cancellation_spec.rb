require 'rails_helper'

RSpec.describe HolidayCancellation do
  include ActiveJob::TestHelper

  let(:org) { { region: "FVG", province: "UD", institute: "CGIL Udine" } }
  let(:employee) { create(:user, :holiday_requesting, first_name: "Angela", last_name: "Tortorella", **org) }

  before { create(:user, :manager, **org, email: "direttore@example.com") }

  it "elimina una richiesta in attesa e avvisa i direttori con i dati della richiesta" do
    holiday = create(:holiday, user: employee, reason: "Richiesta sbagliata")

    expect {
      perform_enqueued_jobs { described_class.call(holiday: holiday) }
    }.to change(Holiday, :count).by(-1)

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq([ "direttore@example.com" ])
    expect(mail.subject).to include("annullata", "Angela Tortorella")
    expect(mail.text_part.decoded).to include("Richiesta sbagliata")
  end

  it "elimina ferie inserite direttamente senza mandare mail" do
    holiday = create(:holiday, :direct, user: employee)

    expect {
      perform_enqueued_jobs { described_class.call(holiday: holiday) }
    }.to change(Holiday, :count).by(-1)

    expect(ActionMailer::Base.deliveries).to be_empty
  end

  it "non elimina una richiesta approvata nel frattempo" do
    holiday = create(:holiday, user: employee)
    Holiday.where(id: holiday.id).update_all(request_approved: true)

    expect {
      described_class.call(holiday: holiday)
    }.not_to change(Holiday, :count)

    expect(holiday).not_to be_destroyed
  end
end
