class PlacesController < ApplicationController
  before_action :set_place, only: %i[show edit update destroy confirm_destroy]

  def index
    @places = policy_scope(Place).ordered
  end

  def show
  end

  def new
    @place = current_user.places.build
    authorize @place
  end

  def create
    @place = current_user.places.build(place_params)
    authorize @place

    if @place.save
      redirect_to places_path, notice: "Luogo creato con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @place.update(place_params)
      redirect_to places_path, notice: "Luogo aggiornato con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
    @place.destroy
    redirect_to places_path, notice: "Luogo eliminato con successo.", status: :see_other
  end

  private

  def set_place
    @place = policy_scope(Place).find(params[:id])
    authorize @place
  end

  def place_params
    params.require(:place).permit(:name, :position)
  end
end
