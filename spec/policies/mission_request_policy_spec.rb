require 'rails_helper'

RSpec.describe MissionRequestPolicy do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let!(:mission_request) { create(:mission_request, user: owner) }

  describe "#show?, #update?, #destroy?" do
    it "consentono al proprietario" do
      policy = described_class.new(owner, mission_request)

      expect(policy.show?).to be true
      expect(policy.update?).to be true
      expect(policy.destroy?).to be true
    end

    it "negano a un altro utente" do
      policy = described_class.new(other_user, mission_request)

      expect(policy.show?).to be false
      expect(policy.update?).to be false
      expect(policy.destroy?).to be false
    end

    it "consentono all'amministratore anche su un record altrui" do
      policy = described_class.new(admin, mission_request)

      expect(policy.show?).to be true
      expect(policy.update?).to be true
      expect(policy.destroy?).to be true
    end
  end

  describe "Scope" do
    let!(:other_mission_request) { create(:mission_request, user: other_user) }

    it "restituisce solo i record dell'utente per un utente normale" do
      scope = described_class::Scope.new(owner, MissionRequest).resolve

      expect(scope).to contain_exactly(mission_request)
    end

    it "restituisce tutti i record per l'amministratore" do
      scope = described_class::Scope.new(admin, MissionRequest).resolve

      expect(scope).to contain_exactly(mission_request, other_mission_request)
    end
  end
end
