# frozen_string_literal: true

class ReimbursementPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    owner?
  end

  def create?
    true
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def confirm_destroy?
    destroy?
  end

  def print?
    true
  end

  private

  # A reimbursement is strictly personal: not even an administrator reaches the
  # ones belonging to somebody else through the front office.
  def owner?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
