module Director
  class MissionRequestsController < ApplicationController
    before_action :authenticate_manager
    before_action :set_mission_request, only: :show

    def index
      @mission_requests = director_scope.ordered
    end

    def show
    end

    private

    def authenticate_manager
      redirect_to root_path, alert: "Non sei autorizzato a eseguire questa azione." unless current_user.manager?
    end

    def verify_pundit_usage
      action_name == "index" ? verify_policy_scoped : verify_authorized
    end

    def director_scope
      policy_scope(MissionRequest, policy_scope_class: DirectorMissionRequestPolicy::Scope)
    end

    def set_mission_request
      @mission_request = director_scope.find(params[:id])
      authorize @mission_request, policy_class: DirectorMissionRequestPolicy
    end
  end
end
