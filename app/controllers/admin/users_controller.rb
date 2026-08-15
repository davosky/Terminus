module Admin
  class UsersController < Admin::ApplicationController
    # Devise's password fields should only be required on create; on update,
    # a blank password means "leave it unchanged".
    def resource_params
      params.require(resource_class.model_name.param_key)
        .permit(dashboard.permitted_attributes(action_name))
        .reject { |key, value| key.start_with?("password") && value.blank? }
    end

    def download_signature
      send_uploaded_file(requested_resource.user_signature)
    end

    def download_validator_signature
      send_uploaded_file(requested_resource.validator_signature)
    end

    def download_confirmator_signature
      send_uploaded_file(requested_resource.confirmator_signature)
    end

    private

    def send_uploaded_file(file)
      raise ActiveRecord::RecordNotFound if file.blank?

      send_file file.path, disposition: "inline", type: file.file.content_type
    end
  end
end
