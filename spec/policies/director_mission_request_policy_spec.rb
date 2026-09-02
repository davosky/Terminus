require 'rails_helper'

RSpec.describe DirectorMissionRequestPolicy do
  let(:requester) { create(:user, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let(:matching_manager) { create(:user, :manager, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let(:other_manager) { create(:user, :manager, region: "FVG", province: "TS", institute: "CGIL Udine") }
  let(:regular_user) { create(:user, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let!(:mission_request) { create(:mission_request, user: requester) }

  describe "#show?" do
    it "consente al manager con region/province/institute combacianti" do
      expect(described_class.new(matching_manager, mission_request).show?).to be true
    end

    it "nega a un manager di un'altra sede" do
      expect(described_class.new(other_manager, mission_request).show?).to be false
    end

    it "nega a un utente non manager" do
      expect(described_class.new(regular_user, mission_request).show?).to be false
    end

    it "nega se il manager non ha region/province/institute valorizzati" do
      blank_requester = create(:user, region: nil, province: nil, institute: nil)
      blank_manager = create(:user, :manager, region: nil, province: nil, institute: nil)
      blank_request = create(:mission_request, user: blank_requester)

      expect(described_class.new(blank_manager, blank_request).show?).to be false
    end
  end

  describe "Scope" do
    it "restituisce solo le richieste dei dipendenti che condividono region/province/institute" do
      other_requester = create(:user, region: "FVG", province: "TS", institute: "CGIL Udine")
      other_request = create(:mission_request, user: other_requester)

      scope = described_class::Scope.new(matching_manager, MissionRequest).resolve

      expect(scope).to contain_exactly(mission_request)
      expect(scope).not_to include(other_request)
    end

    it "restituisce uno scope vuoto per un utente non manager" do
      expect(described_class::Scope.new(regular_user, MissionRequest).resolve).to be_empty
    end

    it "restituisce uno scope vuoto se il manager non ha region/province/institute valorizzati" do
      blank_manager = create(:user, :manager, region: nil, province: nil, institute: nil)

      expect(described_class::Scope.new(blank_manager, MissionRequest).resolve).to be_empty
    end
  end
end
