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
      redirect_to mission_requests_path, notice: "Richiesta missione creata con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @mission_request.update(mission_request_params)
      redirect_to mission_requests_path, notice: "Richiesta missione aggiornata con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
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
      :path_lenght_fr, :highway_cost_fr
    )
  end
end
