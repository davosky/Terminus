class HolidaysController < ApplicationController
  before_action :set_holiday, only: %i[show edit update destroy confirm_destroy]
  helper_method :assignable_users

  def index
    # ponytail: loads every visible approved holiday and lets simple_calendar pick the month; scope to the month range if the list grows large
    @holidays = policy_scope(Holiday).approved.includes(:user)
    @calendar_users = current_user.holiday_team.order(:id).to_a
  end

  def requests
    @holidays = policy_scope(Holiday).where(user: current_user, request_approved: [ nil, false ]).order(start_date: :desc)
  end

  def show
  end

  def new
    @holiday = current_user.holidays.build
    authorize @holiday
  end

  def create
    @holiday = Holiday.new(holiday_params.merge(user: holiday_owner)).submitted_by(current_user)
    authorize @holiday

    if @holiday.save
      announce_to_directors
      redirect_to after_save_path, notice: @holiday.pending? ? "Richiesta ferie inviata al direttore." : "Ferie registrate con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    return redirect_to(holiday_path(@holiday), alert: locked_message("modificato")) if @holiday.locked?

    if @holiday.update(holiday_params)
      @holiday.refresh_director_pages
      redirect_to after_save_path, notice: "Ferie aggiornate con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
    HolidayCancellation.call(holiday: @holiday)
    return redirect_to(holiday_path(@holiday), alert: locked_message("eliminato")) unless @holiday.destroyed?

    notice = @holiday.requested? ? "Richiesta ferie annullata: il direttore è stato avvisato via email." : "Ferie eliminate con successo."
    redirect_to after_save_path, notice: notice, status: :see_other
  end

  private

  def set_holiday
    @holiday = policy_scope(Holiday).find(params[:id])
    authorize @holiday
  end

  def holiday_params
    params.require(:holiday).permit(:start_date, :end_date, :reason)
  end

  # Only a director may pick someone else, and only among their colleagues.
  def holiday_owner
    user_id = params.dig(:holiday, :user_id)
    user_id.present? ? assignable_users.find(user_id) : current_user
  end

  def assignable_users
    current_user.holiday_team.order(:last_name, :first_name)
  end

  # Directors' open holiday pages always refresh; only a pending request also mails them.
  def announce_to_directors
    @holiday.refresh_director_pages
    return unless @holiday.pending?

    @holiday.candidate_validators.find_each { |director| HolidayMailer.validation_request(@holiday, director).deliver_later }
  end

  def after_save_path
    @holiday.pending? ? requests_holidays_path : holidays_path(start_date: @holiday.start_date)
  end

  def locked_message(verb)
    "Richiesta ferie #{@holiday.decision_label.downcase} - Questo record non può essere #{verb}."
  end

  def verify_pundit_usage
    %w[index requests].include?(action_name) ? verify_policy_scoped : verify_authorized
  end
end
