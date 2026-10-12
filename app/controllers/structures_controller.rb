class StructuresController < ApplicationController
  before_action :set_structure, only: %i[show edit update confirm_destroy destroy]

  def index
    @structures = policy_scope(Structure).ordered
  end

  def show
  end

  def new
    @structure = Structure.new
  end

  def create
    @structure = current_user.structures.new(structure_params)
    if @structure.save
      redirect_to structures_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @structure.update(structure_params)
      redirect_to structures_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def confirm_destroy
  end

  def destroy
    @structure.destroy!
    redirect_to structures_path, notice: t(".success"), status: :see_other
  end

  private

  def set_structure
    @structure = policy_scope(Structure).find(params[:id])
    authorize @structure
  end

  def structure_params
    params.expect(structure: %i[name position])
  end
end
