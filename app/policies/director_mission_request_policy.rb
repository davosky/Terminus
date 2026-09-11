# frozen_string_literal: true

# Read-only view for a director (a manager) over the mission requests of the
# employees sharing their region/province/institute. Reimbursements are never
# exposed here — they stay personal to each user (see ReimbursementPolicy::Scope).
class DirectorMissionRequestPolicy < ApplicationPolicy
  def show?
    director?
  end

  def approve?
    director? && record.pending?
  end

  def reject?
    approve?
  end

  private

  def director?
    user&.manager? && user.colleagues.exists?(record.user_id)
  end

  class Scope < Scope
    def resolve
      user&.manager? ? scope.where(user: user.colleagues) : scope.none
    end
  end
end
