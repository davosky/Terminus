class PathsController < ApplicationController
  before_action :set_path, only: %i[show edit update destroy confirm_destroy]

  def index
    @paths = policy_scope(Path).ordered
  end

  def show
  end

  def new
    @path = current_user.paths.build
    authorize @path
  end

  def create
    @path = current_user.paths.build(path_params)
    authorize @path

    if @path.save
      redirect_to paths_path, notice: "Percorso creato con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @path.update(path_params)
      redirect_to paths_path, notice: "Percorso aggiornato con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
    @path.destroy
    redirect_to paths_path, notice: "Percorso eliminato con successo.", status: :see_other
  end

  private

  def set_path
    @path = policy_scope(Path).find(params[:id])
    authorize @path
  end

  def path_params
    params.require(:path).permit(:name, :lenght, :highway_cost, :position)
  end
end
