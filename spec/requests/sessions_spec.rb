require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let!(:user) { create(:user, username: "mario", password: "pAssword1234567") }

  after { travel_back }

  def attempt_login(password)
    post user_session_path, params: { user: { username: "mario", password: password } }
  end

  it "blocca l'account dopo 3 tentativi di accesso falliti" do
    3.times { attempt_login("password_errata") }

    expect(user.reload.access_locked?).to be(true)
  end

  it "impedisce l'accesso con la password corretta quando l'account è bloccato" do
    3.times { attempt_login("password_errata") }

    attempt_login("pAssword1234567")

    expect(response.body).to include("bloccato")
  end

  it "non blocca l'account dopo meno di 3 tentativi falliti" do
    2.times { attempt_login("password_errata") }

    expect(user.reload.access_locked?).to be(false)
  end

  it "sblocca automaticamente l'account trascorso il periodo di unlock_in" do
    3.times { attempt_login("password_errata") }
    expect(user.reload.access_locked?).to be(true)

    travel 1.hour + 1.second

    attempt_login("pAssword1234567")

    expect(user.reload.access_locked?).to be(false)
  end
end
