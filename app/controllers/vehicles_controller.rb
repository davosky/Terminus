class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show edit update destroy confirm_destroy]

  def index
    @vehicles = policy_scope(Vehicle).ordered
  end

  def show
  end

  def new
    @vehicle = current_user.vehicles.build
    authorize @vehicle
  end

  def create
    @vehicle = current_user.vehicles.build(vehicle_params)
    authorize @vehicle

    if @vehicle.save
      redirect_to vehicles_path, notice: "Veicolo creato con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to vehicles_path, notice: "Veicolo aggiornato con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
    @vehicle.destroy
    redirect_to vehicles_path, notice: "Veicolo eliminato con successo.", status: :see_other
  end

  private

  def set_vehicle
    @vehicle = policy_scope(Vehicle).find(params[:id])
    authorize @vehicle
  end

  def vehicle_params
    params.require(:vehicle).permit(:name, :producer, :licence_plate, :cost_per_km, :position)
  end
end
