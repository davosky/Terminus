# frozen_string_literal: true

# Users manage only their own transports; locked ones can only be changed in Madmin
class TransportPolicy < ApplicationPolicy
  def show?
    owner?
  end

  def update?
    owner? && !record.locked?
  end

  def destroy?
    update?
  end

  # The edit and confirm_destroy pages open for locked records too: they show the warning
  def edit?
    owner?
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
