# frozen_string_literal: true

# Same ownership rules as the other personal records, gated behind the
# "Richiede Missione" flag: without it the resource is unreachable.
class MissionRequestPolicy < OwnedRecordPolicy
  def index?
    mission_requesting_user?
  end

  def create?
    mission_requesting_user?
  end

  private

  def owner?
    mission_requesting_user? && super
  end

  def mission_requesting_user?
    user&.mission_requesting_user?
  end

  class Scope < OwnedRecordPolicy::Scope
    def resolve
      return scope.none unless user&.mission_requesting_user?

      super
    end
  end
end
