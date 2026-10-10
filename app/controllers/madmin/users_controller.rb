module Madmin
  class UsersController < Madmin::ResourceController
    def create
      super
      CreateDefaultTransports.call(@record) if @record.persisted?
    end

    private

    # A blank password field means "leave the password unchanged"
    def resource_params
      super.reject { |name, value| name == "password" && value.blank? }
    end
  end
end
