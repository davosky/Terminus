class TransportsController < ApplicationController
  before_action :set_transport, only: %i[show edit update destroy confirm_destroy]

  def index
    @transports = policy_scope(Transport).ordered
  end

  def show
  end

  def new
    @transport = current_user.transports.build
    authorize @transport
  end

  def create
    @transport = current_user.transports.build(transport_params)
    authorize @transport

    if @transport.save
      redirect_to transports_path, notice: "Trasporto creato con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @transport.protected_record?
      redirect_to edit_transport_path(@transport), alert: "Record di Sistema - Questo record non può essere modificato."
      return
    end

    if @transport.update(transport_params)
      redirect_to transports_path, notice: "Trasporto aggiornato con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
  end

  def destroy
    if @transport.protected_record?
      redirect_to confirm_destroy_transport_path(@transport), alert: "Record di Sistema - Questo record non può essere eliminato."
      return
    end

    @transport.destroy
    redirect_to transports_path, notice: "Trasporto eliminato con successo.", status: :see_other
  end

  private

  def set_transport
    @transport = policy_scope(Transport).find(params[:id])
    authorize @transport
  end

  def transport_params
    params.require(:transport).permit(:name, :position)
  end
end
