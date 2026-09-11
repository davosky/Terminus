require 'rails_helper'

RSpec.describe HolidayPolicy do
  let(:org) { { region: "FVG", province: "UD", institute: "CGIL Udine" } }
  let(:owner) { create(:user, **org) }
  let(:colleague) { create(:user, **org) }
  let(:director) { create(:user, :manager, **org) }
  let(:other_director) { create(:user, :manager, **org, province: "TS") }
  let!(:holiday) { create(:holiday, user: owner) }

  describe "#show?" do
    it "consente al proprietario e al suo direttore" do
      expect(described_class.new(owner, holiday).show?).to be true
      expect(described_class.new(director, holiday).show?).to be true
    end

    it "nega a un collega, a un direttore di un'altra sede e a un admin non manager" do
      expect(described_class.new(colleague, holiday).show?).to be false
      expect(described_class.new(other_director, holiday).show?).to be false
      expect(described_class.new(create(:user, :admin, **org), holiday).show?).to be false
    end
  end

  describe "#update?, #destroy?" do
    it "consentono solo al proprietario, non al direttore" do
      expect(described_class.new(owner, holiday).update?).to be true
      expect(described_class.new(owner, holiday).destroy?).to be true
      expect(described_class.new(director, holiday).update?).to be false
      expect(described_class.new(director, holiday).destroy?).to be false
    end
  end

  describe "#approve?, #reject?" do
    it "consentono al direttore della sede finché la richiesta è in attesa" do
      policy = described_class.new(director, holiday)

      expect(policy.approve?).to be true
      expect(policy.reject?).to be true
    end

    it "negano una richiesta già decisa" do
      holiday.update!(request_approved: true)

      expect(described_class.new(director, holiday).approve?).to be false
    end

    it "negano al proprietario e a un direttore di un'altra sede" do
      expect(described_class.new(owner, holiday).approve?).to be false
      expect(described_class.new(other_director, holiday).approve?).to be false
    end
  end

  describe "ferie inserite direttamente" do
    let!(:direct) { create(:holiday, :direct, user: owner) }

    it "restano modificabili ed eliminabili dal proprietario senza flag e dal suo direttore" do
      [ owner, director ].each do |user|
        policy = described_class.new(user, direct)

        expect(policy.update?).to be true
        expect(policy.destroy?).to be true
      end
    end

    it "non sono modificabili dal proprietario che deve richiedere le ferie" do
      owner.update!(holiday_requesting_user: true)

      expect(described_class.new(owner, direct).update?).to be false
      expect(described_class.new(owner, direct).destroy?).to be false
    end

    it "non sono modificabili da un collega o da un direttore di un'altra sede" do
      expect(described_class.new(colleague, direct).update?).to be false
      expect(described_class.new(other_director, direct).update?).to be false
    end
  end

  describe "Scope" do
    let!(:director_holiday) { create(:holiday, user: director) }
    let!(:outsider_holiday) { create(:holiday, user: create(:user, **org, province: "TS")) }

    def resolve(user) = described_class::Scope.new(user, Holiday).resolve

    it "restituisce a un dipendente solo le proprie ferie" do
      expect(resolve(owner)).to contain_exactly(holiday)
    end

    it "restituisce al direttore le proprie e quelle dei dipendenti della sede" do
      expect(resolve(director)).to contain_exactly(holiday, director_holiday)
    end

    it "tratta un admin anche manager come un direttore" do
      admin_manager = create(:user, :admin, manager: true, **org)

      expect(resolve(admin_manager)).to contain_exactly(holiday, director_holiday)
    end

    it "restituisce a un admin non manager solo le proprie ferie" do
      admin = create(:user, :admin, **org)
      own = create(:holiday, user: admin)

      expect(resolve(admin)).to contain_exactly(own)
    end

    it "restituisce a un direttore senza sede solo le proprie ferie" do
      lonely = create(:user, :manager)
      own = create(:holiday, user: lonely)

      expect(resolve(lonely)).to contain_exactly(own)
    end
  end
end
