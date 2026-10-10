module Madmin
  class UsersController < Madmin::ResourceController
    private

    # A blank password field means "leave the password unchanged"
    def resource_params
      super.reject { |name, value| name == "password" && value.blank? }
    end
  end
end
