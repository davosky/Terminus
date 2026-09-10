require 'rails_helper'

RSpec.describe MissionRequestPolicy do
  let(:owner) { create(:user, :mission_requesting) }
  let(:other_user) { create(:user, :mission_requesting) }
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

    it "negano ad amministratore e amministrazione su un record altrui" do
      %i[admin payroll].each do |role|
        policy = described_class.new(create(:user, role, :mission_requesting), mission_request)

        expect(policy.show?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
      end
    end
  end

  describe "senza il flag Richiede Missione" do
    let(:without_flag) { create(:user) }

    it "nega elenco, creazione e accesso ai propri record" do
      policy = described_class.new(without_flag, create(:mission_request, user: without_flag))

      expect(policy.index?).to be false
      expect(policy.create?).to be false
      expect(policy.show?).to be false
      expect(policy.update?).to be false
      expect(policy.destroy?).to be false
    end

    it "restituisce uno scope vuoto" do
      create(:mission_request, user: without_flag)

      expect(described_class::Scope.new(without_flag, MissionRequest).resolve).to be_empty
    end
  end

  describe "Scope" do
    let!(:other_mission_request) { create(:mission_request, user: other_user) }

    it "restituisce solo i record dell'utente per un utente normale" do
      scope = described_class::Scope.new(owner, MissionRequest).resolve

      expect(scope).to contain_exactly(mission_request)
    end

    it "restituisce solo i propri record ad amministratore e amministrazione" do
      %i[admin payroll].each do |role|
        privileged = create(:user, role, :mission_requesting)
        own = create(:mission_request, user: privileged)

        expect(described_class::Scope.new(privileged, MissionRequest).resolve).to contain_exactly(own)
      end
    end
  end
end
