class StructuresController < ApplicationController
  before_action :set_structure, only: %i[show edit update destroy confirm_destroy]

  def index
    @structures = policy_scope(Structure).ordered
  end

  def show
  end

  def new
    @structure = current_user.structures.build
    authorize @structure
  end

  def create
    @structure = current_user.structures.build(structure_params)
    authorize @structure

    if @structure.save
      redirect_to structures_path, notice: "Struttura creata con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @structure.update(structure_params)
      redirect_to structures_path, notice: "Struttura aggiornata con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
    @structure.destroy
    redirect_to structures_path, notice: "Struttura eliminata con successo.", status: :see_other
  end

  private

  def set_structure
    @structure = policy_scope(Structure).find(params[:id])
    authorize @structure
  end

  def structure_params
    params.require(:structure).permit(:name, :position)
  end
end
