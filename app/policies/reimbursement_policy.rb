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

  private

  def owner?
    record.user == user || admin?
  end

  class Scope < Scope
    def resolve
      user&.admin? ? scope.all : scope.where(user: user)
    end
  end
end
