# frozen_string_literal: true

# Users manage only their own records; administrators reach the others in Madmin
class OwnedRecordPolicy < ApplicationPolicy
  def show?
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    update?
  end

  def confirm_destroy?
    owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user_code: user.user_code)
    end
  end

  private

  def owner?
    record.user_code == user.user_code
  end
end
