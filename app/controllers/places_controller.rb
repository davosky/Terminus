class PlacesController < ApplicationController
  before_action :set_place, only: %i[show edit update confirm_destroy destroy]

  def index
    @places = policy_scope(Place).ordered
  end

  def show
  end

  def new
    @place = Place.new
  end

  def create
    @place = current_user.places.new(place_params)
    if @place.save
      redirect_to places_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @place.update(place_params)
      redirect_to places_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def confirm_destroy
  end

  def destroy
    @place.destroy!
    redirect_to places_path, notice: t(".success"), status: :see_other
  end

  private

  def set_place
    @place = policy_scope(Place).find(params[:id])
    authorize @place
  end

  def place_params
    params.expect(place: %i[name position])
  end
end
