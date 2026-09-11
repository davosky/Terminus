module MissionRequestsHelper
  def mission_request_index_border_class(mission_request)
    if mission_request.request_approved?
      "border-success"
    elsif mission_request.rejected?
      "border-danger"
    else
      ""
    end
  end

  def request_age_background_class(mission_request)
    return "" unless mission_request.request_date

    case (Date.current - mission_request.request_date).to_i
    when 0..2 then "bg-success-subtle"
    when 3..4 then "bg-warning-subtle"
    else "bg-danger-subtle"
    end
  end
end
