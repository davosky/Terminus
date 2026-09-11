class MissionRequestValidationsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_pundit_usage

  before_action :set_mission_request

  # GET: shows a confirmation page. Approving mutates state, so it must never
  # happen on a bare GET - email link-scanners/prefetchers (corporate mail
  # gateways, Outlook Safe Links, etc.) follow links automatically and would
  # otherwise silently approve requests before a human ever opens the mail.
  def approve_form
    render_result(unavailable_message) if unavailable_message
  end

  def approve
    return render_result(unavailable_message) if unavailable_message

    MissionRequestApproval.call(mission_request: @mission_request)
    render_result("Richiesta missione approvata con successo.")
  end

  def reject_form
    render_result(unavailable_message) if unavailable_message
  end

  def reject
    return render_result(unavailable_message) if unavailable_message

    @mission_request = MissionRequestRejection.call(mission_request: @mission_request, rejection_motivation: params[:rejection_motivation])

    if @mission_request.errors.any?
      render :reject_form, status: :unprocessable_entity
    else
      render_result("Richiesta missione respinta con successo.")
    end
  end

  private

  def set_mission_request
    @mission_request = MissionRequest.find_signed(params[:token], purpose: "mission_request_validation")
  end

  def unavailable_message
    if @mission_request.nil?
      "Il link non è valido o è scaduto."
    elsif !@mission_request.pending?
      "Questa richiesta missione è già stata elaborata."
    end
  end

  def render_result(message)
    @message = message
    render :result
  end
end
