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

    SAFE_SIGNATURE_CONTENT_TYPES = { "png" => "image/png", "jpg" => "image/jpeg", "jpeg" => "image/jpeg" }.freeze

    def send_uploaded_file(file)
      raise ActiveRecord::RecordNotFound if file.blank?

      extension = File.extname(file.path).delete(".").downcase
      content_type = SAFE_SIGNATURE_CONTENT_TYPES.fetch(extension, "application/octet-stream")
      send_file file.path, disposition: "inline", type: content_type
    end
  end
end
