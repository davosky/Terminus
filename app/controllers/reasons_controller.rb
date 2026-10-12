class ReasonsController < ApplicationController
  before_action :set_reason, only: %i[show edit update confirm_destroy destroy]

  def index
    @reasons = policy_scope(Reason).ordered
  end

  def show
  end

  def new
    @reason = Reason.new
  end

  def create
    @reason = current_user.reasons.new(reason_params)
    if @reason.save
      redirect_to reasons_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @reason.update(reason_params)
      redirect_to reasons_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def confirm_destroy
  end

  def destroy
    @reason.destroy!
    redirect_to reasons_path, notice: t(".success"), status: :see_other
  end

  private

  def set_reason
    @reason = policy_scope(Reason).find(params[:id])
    authorize @reason
  end

  def reason_params
    params.expect(reason: %i[name position])
  end
end
