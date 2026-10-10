require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { is_expected.to be_valid }

  %i[username email first_name last_name institute office].each do |attribute|
    context "quando #{attribute} è assente" do
      before { user[attribute] = nil }

      it { is_expected.not_to be_valid }
    end
  end

  context "quando username è già in uso con maiuscole diverse" do
    before { create(:user, username: "Mario") }

    it { expect(build(:user, username: "mario")).not_to be_valid }
  end

  context "quando gender non è M, F o A" do
    before { user.gender = "X" }

    it { is_expected.not_to be_valid }
  end

  context "quando region e province sono in minuscolo" do
    subject(:user) { build(:user, region: "fvg", province: " ts ") }

    it "le normalizza in maiuscolo" do
      expect([ user.region, user.province ]).to eq(%w[FVG TS])
    end
  end

  context "quando region non ha tre lettere" do
    before { user.region = "FV" }

    it { is_expected.not_to be_valid }
  end

  context "quando province ha tre lettere" do
    it "viene salvata" do
      expect(create(:user, province: "FVG").reload.province).to eq("FVG")
    end
  end

  %w[T TRST].each do |province|
    context "quando province è #{province}" do
      before { user.province = province }

      it { is_expected.not_to be_valid }
    end
  end

  context "quando viene salvato" do
    it "assegna user_code progressivi" do
      first, second = create_list(:user, 2).map { |u| u.reload.user_code }
      expect(second).to eq(first + 1)
    end
  end

  describe "#full_name" do
    it { expect(build(:user, first_name: "Davo", last_name: "Davosky").full_name).to eq("Davo Davosky") }
  end
end
