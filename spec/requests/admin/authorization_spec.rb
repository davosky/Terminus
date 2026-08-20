require 'rails_helper'

RSpec.describe "Admin authorization", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:manager) { create(:user, :manager) }
  let(:payroll) { create(:user, payroll: true) }
  let(:regular) { create(:user) }

  describe "GET /admin" do
    it "consente l'accesso all'amministratore" do
      sign_in admin
      get admin_root_path

      expect(response).to have_http_status(:ok)
    end

    it "nega l'accesso al responsabile" do
      sign_in manager
      get admin_root_path

      expect(response).to redirect_to(root_path)
    end

    it "nega l'accesso all'utente di amministrazione (payroll)" do
      sign_in payroll
      get admin_root_path

      expect(response).to redirect_to(root_path)
    end

    it "nega l'accesso al dipendente" do
      sign_in regular
      get admin_root_path

      expect(response).to redirect_to(root_path)
    end
  end
end
