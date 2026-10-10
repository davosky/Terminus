class TransportsController < ApplicationController
  before_action :set_transport, only: %i[show edit update confirm_destroy destroy]

  def index
    @transports = policy_scope(Transport).ordered
  end

  def show
  end

  def new
    @transport = Transport.new
  end

  def create
    @transport = current_user.transports.new(transport_params)
    if @transport.save
      redirect_to transports_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @transport.update(transport_params)
      redirect_to transports_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def confirm_destroy
  end

  def destroy
    @transport.destroy!
    redirect_to transports_path, notice: t(".success"), status: :see_other
  end

  private

  def set_transport
    @transport = policy_scope(Transport).find(params[:id])
    authorize @transport
  end

  def transport_params
    params.expect(transport: %i[transport_name transport_position])
  end
end
