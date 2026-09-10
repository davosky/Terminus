require 'rails_helper'

RSpec.describe PathPolicy do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:path) { create(:path, user: owner) }

  describe "#show?, #update?, #destroy?" do
    it "consentono al proprietario" do
      policy = described_class.new(owner, path)

      expect(policy.show?).to be true
      expect(policy.update?).to be true
      expect(policy.destroy?).to be true
    end

    it "negano a un altro utente" do
      policy = described_class.new(other_user, path)

      expect(policy.show?).to be false
      expect(policy.update?).to be false
      expect(policy.destroy?).to be false
    end

    it "negano ai ruoli privilegiati su un record altrui" do
      %i[admin manager payroll].each do |role|
        policy = described_class.new(create(:user, role), path)

        expect(policy.show?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
      end
    end
  end

  describe "Scope" do
    let!(:other_path) { create(:path, user: other_user) }

    it "restituisce solo i record dell'utente per un utente normale" do
      scope = described_class::Scope.new(owner, Path).resolve

      expect(scope).to contain_exactly(path)
    end

    it "restituisce solo i propri record ai ruoli privilegiati" do
      %i[admin manager payroll].each do |role|
        privileged = create(:user, role)
        own = create(:path, user: privileged)

        expect(described_class::Scope.new(privileged, Path).resolve).to contain_exactly(own)
      end
    end
  end
end
