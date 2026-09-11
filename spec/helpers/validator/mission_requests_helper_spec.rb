require 'rails_helper'

RSpec.describe Validator::MissionRequestsHelper, type: :helper do
  describe "#request_age_background_class" do
    def age_class(days_ago)
      helper.request_age_background_class(build(:mission_request, request_date: Date.current - days_ago))
    end

    it "colora di verde le richieste fino a 2 giorni" do
      expect(age_class(0)).to eq("bg-success-subtle")
      expect(age_class(2)).to eq("bg-success-subtle")
    end

    it "colora di giallo le richieste di 3 o 4 giorni" do
      expect(age_class(3)).to eq("bg-warning-subtle")
      expect(age_class(4)).to eq("bg-warning-subtle")
    end

    it "colora di rosso le richieste più vecchie" do
      expect(age_class(5)).to eq("bg-danger-subtle")
    end

    it "non colora una richiesta senza data" do
      expect(helper.request_age_background_class(build(:mission_request, request_date: nil))).to eq("")
    end
  end
end
