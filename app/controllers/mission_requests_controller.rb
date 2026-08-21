class MissionRequestsController < ApplicationController
  before_action :set_mission_request, only: %i[show edit update destroy confirm_destroy]

  def index
    @mission_requests = policy_scope(MissionRequest).ordered
  end

  def show
  end

  def new
    @mission_request = current_user.mission_requests.build(request_date: Date.current)
    authorize @mission_request
  end

  def create
    @mission_request = current_user.mission_requests.build(mission_request_params)
    @mission_request.name = MissionRequestCodeGenerator.call(user: current_user)
    authorize @mission_request

    if @mission_request.save
      notify_candidate_validators
      redirect_to mission_requests_path, notice: "Richiesta missione creata con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @mission_request.locked?
      redirect_to edit_mission_request_path(@mission_request), alert: "Richiesta #{@mission_request.decision_label} - Questo record non può essere modificato."
      return
    end

    if @mission_request.update(mission_request_params)
      redirect_to mission_requests_path, notice: "Richiesta missione aggiornata con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
    if @mission_request.locked?
      redirect_to confirm_destroy_mission_request_path(@mission_request), alert: "Richiesta #{@mission_request.decision_label} - Questo record non può essere eliminato."
      return
    end

    @mission_request.destroy
    redirect_to mission_requests_path, notice: "Richiesta missione eliminata con successo.", status: :see_other
  end

  private

  def set_mission_request
    @mission_request = policy_scope(MissionRequest).find(params[:id])
    authorize @mission_request
  end

  def mission_request_params
    params.require(:mission_request).permit(
      :departure_date, :return_date, :request_date,
      :reason_id, :place_id, :structure_id, :path_id,
      :reason_fr, :place_fr, :structure_fr, :path_fr,
      :path_lenght_fr, :highway_cost_fr,
      :transport_id, :vehicle_id
    )
  end

  def notify_candidate_validators
    @mission_request.candidate_validators.find_each do |validator|
      MissionRequestMailer.validation_request(@mission_request, validator).deliver_later
    end
  end
end
