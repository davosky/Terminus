class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :verify_pundit_usage, unless: :devise_controller?

  private

  def verify_pundit_usage
    action_name == "index" ? verify_policy_scoped : verify_authorized
  end

  def user_not_authorized
    flash[:alert] = "Non sei autorizzato a eseguire questa azione."
    redirect_to(request.referrer || root_path)
  end
end
