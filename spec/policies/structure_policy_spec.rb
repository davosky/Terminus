require 'rails_helper'

RSpec.describe StructurePolicy do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let!(:structure) { create(:structure, user: owner) }

  describe "#show?, #update?, #destroy?" do
    it "consentono al proprietario" do
      policy = described_class.new(owner, structure)

      expect(policy.show?).to be true
      expect(policy.update?).to be true
      expect(policy.destroy?).to be true
    end

    it "negano a un altro utente" do
      policy = described_class.new(other_user, structure)

      expect(policy.show?).to be false
      expect(policy.update?).to be false
      expect(policy.destroy?).to be false
    end

    it "consentono all'amministratore anche su un record altrui" do
      policy = described_class.new(admin, structure)

      expect(policy.show?).to be true
      expect(policy.update?).to be true
      expect(policy.destroy?).to be true
    end
  end

  describe "Scope" do
    let!(:other_structure) { create(:structure, user: other_user) }

    it "restituisce solo i record dell'utente per un utente normale" do
      scope = described_class::Scope.new(owner, Structure).resolve

      expect(scope).to contain_exactly(structure)
    end

    it "restituisce tutti i record per l'amministratore" do
      scope = described_class::Scope.new(admin, Structure).resolve

      expect(scope).to contain_exactly(structure, other_structure)
    end
  end
end
