# frozen_string_literal: true

class ValidatorMissionRequestPolicy < ApplicationPolicy
  def approve?
    validator? && record.pending?
  end

  def reject?
    validator? && record.pending?
  end

  private

  def validator?
    return false unless user&.manager?

    record.user.region == user.region &&
      record.user.province == user.province &&
      record.user.institute == user.institute
  end

  class Scope < Scope
    def resolve
      return scope.none unless user&.manager?

      scope.joins(:user).where(users: { region: user.region, province: user.province, institute: user.institute })
    end
  end
end
