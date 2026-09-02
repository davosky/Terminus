# frozen_string_literal: true

# Read-only view for a director (a manager) over the mission requests of the
# employees sharing their region/province/institute. Reimbursements are never
# exposed here — they stay personal to each user (see ReimbursementPolicy::Scope).
class DirectorMissionRequestPolicy < ApplicationPolicy
  def show?
    same_organisational_scope?
  end

  private

  def same_organisational_scope?
    return false unless user&.manager?
    return false if user.region.blank? || user.province.blank? || user.institute.blank?

    record.user.region == user.region &&
      record.user.province == user.province &&
      record.user.institute == user.institute
  end

  class Scope < Scope
    def resolve
      return scope.none unless user&.manager?
      return scope.none if user.region.blank? || user.province.blank? || user.institute.blank?

      scope.joins(:user).where(users: { region: user.region, province: user.province, institute: user.institute })
    end
  end
end
