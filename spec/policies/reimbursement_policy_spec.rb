require 'rails_helper'

RSpec.describe ReimbursementPolicy do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let!(:reimbursement) { create(:reimbursement, user: owner) }

  describe "#show?, #update?, #destroy?" do
    it "consentono al proprietario" do
      policy = described_class.new(owner, reimbursement)

      expect(policy.show?).to be true
      expect(policy.update?).to be true
      expect(policy.destroy?).to be true
    end

    it "negano a un altro utente" do
      policy = described_class.new(other_user, reimbursement)

      expect(policy.show?).to be false
      expect(policy.update?).to be false
      expect(policy.destroy?).to be false
    end

    it "negano all'amministratore su un record altrui" do
      policy = described_class.new(admin, reimbursement)

      expect(policy.show?).to be false
      expect(policy.update?).to be false
      expect(policy.destroy?).to be false
    end
  end

  describe "Scope" do
    let!(:other_reimbursement) { create(:reimbursement, user: other_user) }

    it "restituisce solo i record dell'utente per un utente normale" do
      scope = described_class::Scope.new(owner, Reimbursement).resolve

      expect(scope).to contain_exactly(reimbursement)
    end

    it "restituisce solo i propri record anche per l'amministratore" do
      admin_reimbursement = create(:reimbursement, user: admin)

      scope = described_class::Scope.new(admin, Reimbursement).resolve

      expect(scope).to contain_exactly(admin_reimbursement)
    end
  end
end
