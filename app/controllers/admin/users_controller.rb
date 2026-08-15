module Admin
  class UsersController < Admin::ApplicationController
    # Devise's password fields should only be required on create; on update,
    # a blank password means "leave it unchanged".
    def resource_params
      params.require(resource_class.model_name.param_key)
        .permit(dashboard.permitted_attributes(action_name))
        .reject { |key, value| key.start_with?("password") && value.blank? }
    end
  end
end
