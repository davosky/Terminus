module Validator
  class MissionRequestsController < ApplicationController
    before_action :authenticate_manager
    before_action :set_mission_request, only: %i[approve reject]

    def index
      @mission_requests = validator_scope.pending.ordered
    end

    def approved
      @mission_requests = validator_scope.approved.ordered
    end

    def approve
      authorize @mission_request, :approve?, policy_class: ValidatorMissionRequestPolicy
      MissionRequestApproval.call(mission_request: @mission_request)
      redirect_to validator_mission_requests_path, notice: "Richiesta missione approvata con successo."
    end

    def reject
      authorize @mission_request, :reject?, policy_class: ValidatorMissionRequestPolicy
      @mission_request = MissionRequestRejection.call(mission_request: @mission_request, rejection_motivation: params[:rejection_motivation])

      if @mission_request.errors.any?
        redirect_to validator_mission_requests_path, alert: @mission_request.errors.full_messages.to_sentence
      else
        redirect_to validator_mission_requests_path, notice: "Richiesta missione respinta con successo."
      end
    end

    private

    def authenticate_manager
      redirect_to root_path, alert: "Non sei autorizzato a eseguire questa azione." unless current_user.manager?
    end

    def verify_pundit_usage
      %w[index approved].include?(action_name) ? verify_policy_scoped : verify_authorized
    end

    def validator_scope
      policy_scope(MissionRequest, policy_scope_class: ValidatorMissionRequestPolicy::Scope)
    end

    def set_mission_request
      @mission_request = MissionRequest.find(params[:id])
    end
  end
end
