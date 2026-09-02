module Director
  class MissionRequestsController < ApplicationController
    before_action :authenticate_manager
    before_action :set_mission_request, only: %i[show approve reject]

    def index
      @mission_requests = director_scope.ordered
    end

    def approved
      @mission_requests = director_scope.approved.ordered
    end

    def rejected
      @mission_requests = director_scope.rejected.ordered
    end

    def show
    end

    def approve
      MissionRequestApproval.call(mission_request: @mission_request)
      redirect_to director_mission_request_path(@mission_request), notice: "Richiesta missione approvata con successo."
    end

    def reject
      @mission_request = MissionRequestRejection.call(mission_request: @mission_request, rejection_motivation: params[:rejection_motivation])

      if @mission_request.errors.any?
        redirect_to director_mission_request_path(@mission_request), alert: @mission_request.errors.full_messages.to_sentence
      else
        redirect_to director_mission_request_path(@mission_request), notice: "Richiesta missione respinta con successo."
      end
    end

    private

    def authenticate_manager
      redirect_to root_path, alert: "Non sei autorizzato a eseguire questa azione." unless current_user.manager?
    end

    def verify_pundit_usage
      %w[index approved rejected].include?(action_name) ? verify_policy_scoped : verify_authorized
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
