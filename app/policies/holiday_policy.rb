# frozen_string_literal: true

# Everyone manages their own holidays. A director (manager) also sees, enters
# and decides on those of the colleagues sharing their region, province and
# institute; the admin flag alone grants nothing extra.
class HolidayPolicy < ApplicationPolicy
  def show?
    owner? || director?
  end

  def create?
    true
  end

  # Requests follow the approval flow: the owner edits them while pending, then
  # they lock. Holidays entered directly stay editable by their owner (unless
  # the owner would need approval) and by the owner's director.
  def update?
    return owner? if record.requested?

    (owner? && !user.requires_holiday_approval?) || director?
  end

  def destroy?
    update?
  end

  def confirm_destroy?
    destroy?
  end

  def approve?
    director? && record.pending?
  end

  def reject?
    approve?
  end

  private

  def owner?
    record.user == user
  end

  def director?
    user.manager? && user.holiday_team.exists?(record.user_id)
  end

  class Scope < Scope
    def resolve
      scope.where(user: user.holiday_team)
    end
  end
end
