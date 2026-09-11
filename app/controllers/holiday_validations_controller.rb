class HolidayValidationsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_pundit_usage

  before_action :set_holiday

  # GET only shows a confirmation page: mail link-scanners follow links on their
  # own and must never approve anything (see MissionRequestValidationsController).
  def approve_form
    render_result(unavailable_message) if unavailable_message
  end

  def approve
    return render_result(unavailable_message) if unavailable_message

    HolidayApproval.call(holiday: @holiday)
    render_result("Richiesta ferie approvata con successo.")
  end

  def reject_form
    render_result(unavailable_message) if unavailable_message
  end

  def reject
    return render_result(unavailable_message) if unavailable_message

    @holiday = HolidayRejection.call(holiday: @holiday, rejection_motivation: params[:rejection_motivation])

    if @holiday.errors.any?
      render :reject_form, status: :unprocessable_entity
    else
      render_result("Richiesta ferie respinta con successo.")
    end
  end

  private

  def set_holiday
    @holiday = Holiday.find_signed(params[:token], purpose: "holiday_validation")
  end

  def unavailable_message
    if @holiday.nil?
      "Il link non è valido, è scaduto o la richiesta è stata annullata."
    elsif !@holiday.pending?
      "Questa richiesta ferie è già stata elaborata."
    end
  end

  def render_result(message)
    @message = message
    render :result
  end
end
