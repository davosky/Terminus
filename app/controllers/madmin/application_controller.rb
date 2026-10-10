module Madmin
  class ApplicationController < Madmin::BaseController
    before_action :authenticate_user!
    before_action :require_admin

    private

    def require_admin
      redirect_to main_app.root_path, alert: t("pundit.not_authorized") unless current_user.admin?
    end
  end
end
