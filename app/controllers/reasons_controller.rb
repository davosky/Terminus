class ReasonsController < ApplicationController
  before_action :set_reason, only: %i[show edit update destroy confirm_destroy]

  def index
    @reasons = policy_scope(Reason).ordered
  end

  def show
  end

  def new
    @reason = current_user.reasons.build
    authorize @reason
  end

  def create
    @reason = current_user.reasons.build(reason_params)
    authorize @reason

    if @reason.save
      redirect_to reasons_path, notice: "Motivo missione creato con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @reason.update(reason_params)
      redirect_to reasons_path, notice: "Motivo missione aggiornato con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
    @reason.destroy
    redirect_to reasons_path, notice: "Motivo missione eliminato con successo.", status: :see_other
  end

  private

  def set_reason
    @reason = policy_scope(Reason).find(params[:id])
    authorize @reason
  end

  def reason_params
    params.require(:reason).permit(:name, :position)
  end
end
