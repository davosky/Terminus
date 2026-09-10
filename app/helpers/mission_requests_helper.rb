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
end
