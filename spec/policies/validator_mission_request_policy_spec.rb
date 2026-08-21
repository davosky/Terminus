require 'rails_helper'

RSpec.describe ValidatorMissionRequestPolicy do
  let(:requester) { create(:user, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let(:matching_manager) { create(:user, :manager, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let(:other_manager) { create(:user, :manager, region: "FVG", province: "TS", institute: "CGIL Udine") }
  let(:regular_user) { create(:user, region: "FVG", province: "UD", institute: "CGIL Udine") }
  let!(:mission_request) { create(:mission_request, user: requester, request_approved: nil) }

  describe "#approve?, #reject?" do
    it "consentono al manager con region/province/institute combacianti" do
      policy = described_class.new(matching_manager, mission_request)

      expect(policy.approve?).to be true
      expect(policy.reject?).to be true
    end

    it "negano a un manager con region/province/institute diversi" do
      policy = described_class.new(other_manager, mission_request)

      expect(policy.approve?).to be false
      expect(policy.reject?).to be false
    end

    it "negano a un utente non manager" do
      policy = described_class.new(regular_user, mission_request)

      expect(policy.approve?).to be false
      expect(policy.reject?).to be false
    end

    it "negano se la richiesta è già stata decisa" do
      mission_request.update!(request_approved: true)
      policy = described_class.new(matching_manager, mission_request)

      expect(policy.approve?).to be false
      expect(policy.reject?).to be false
    end

    it "negano se il manager non ha region/province/institute valorizzati, anche se il richiedente li ha vuoti allo stesso modo" do
      blank_requester = create(:user, region: nil, province: nil, institute: nil)
      blank_manager = create(:user, :manager, region: nil, province: nil, institute: nil)
      blank_mission_request = create(:mission_request, user: blank_requester)
      policy = described_class.new(blank_manager, blank_mission_request)

      expect(policy.approve?).to be false
      expect(policy.reject?).to be false
    end
  end

  describe "Scope" do
    it "restituisce solo le richieste dei richiedenti che condividono region/province/institute" do
      other_requester = create(:user, region: "FVG", province: "TS", institute: "CGIL Udine")
      other_mission_request = create(:mission_request, user: other_requester)

      scope = described_class::Scope.new(matching_manager, MissionRequest).resolve

      expect(scope).to contain_exactly(mission_request)
      expect(scope).not_to include(other_mission_request)
    end

    it "restituisce un scope vuoto per un utente non manager" do
      scope = described_class::Scope.new(regular_user, MissionRequest).resolve

      expect(scope).to be_empty
    end

    it "restituisce un scope vuoto se il manager non ha region/province/institute valorizzati" do
      blank_manager = create(:user, :manager, region: nil, province: nil, institute: nil)

      scope = described_class::Scope.new(blank_manager, MissionRequest).resolve

      expect(scope).to be_empty
    end
  end
end
