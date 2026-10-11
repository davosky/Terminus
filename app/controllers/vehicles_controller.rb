class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show edit update confirm_destroy destroy]

  def index
    @vehicles = policy_scope(Vehicle).ordered
  end

  def show
  end

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = current_user.vehicles.new(vehicle_params)
    if @vehicle.save
      redirect_to vehicles_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to vehicles_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def confirm_destroy
  end

  def destroy
    @vehicle.destroy!
    redirect_to vehicles_path, notice: t(".success"), status: :see_other
  end

  private

  def set_vehicle
    @vehicle = policy_scope(Vehicle).find(params[:id])
    authorize @vehicle
  end

  def vehicle_params
    params.expect(vehicle: %i[producer name licence_plate power cost_per_km position])
  end
end
