class PathsController < ApplicationController
  before_action :set_path, only: %i[show edit update confirm_destroy destroy]

  def index
    @paths = policy_scope(Path).ordered
  end

  def show
  end

  def new
    @path = Path.new
  end

  def create
    @path = current_user.paths.new(path_params)
    if @path.save
      redirect_to paths_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @path.update(path_params)
      redirect_to paths_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def confirm_destroy
  end

  def destroy
    @path.destroy!
    redirect_to paths_path, notice: t(".success"), status: :see_other
  end

  private

  def set_path
    @path = policy_scope(Path).find(params[:id])
    authorize @path
  end

  def path_params
    params.expect(path: %i[name lenght highway_cost position])
  end
end
