module Validator
  module MissionRequestsHelper
    def request_age_background_class(mission_request)
      return "" unless mission_request.request_date

      case (Date.current - mission_request.request_date).to_i
      when 0..2 then "bg-success-subtle"
      when 3..4 then "bg-warning-subtle"
      else "bg-danger-subtle"
      end
    end
  end
end
