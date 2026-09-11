module Director
  class HolidaysController < ApplicationController
    before_action :authenticate_manager
    before_action :set_holiday, only: %i[approve reject]

    def index
      @holidays = policy_scope(Holiday).pending.includes(:user).ordered
    end

    def approve
      HolidayApproval.call(holiday: @holiday)
      redirect_to director_holidays_path, notice: "Richiesta ferie approvata con successo."
    end

    def reject
      @holiday = HolidayRejection.call(holiday: @holiday, rejection_motivation: params[:rejection_motivation])

      if @holiday.errors.any?
        redirect_to director_holidays_path, alert: @holiday.errors.full_messages.to_sentence
      else
        redirect_to director_holidays_path, notice: "Richiesta ferie respinta con successo."
      end
    end

    private

    def set_holiday
      @holiday = policy_scope(Holiday).find(params[:id])
      authorize @holiday
    end
  end
end
