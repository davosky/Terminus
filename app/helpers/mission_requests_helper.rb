module MissionRequestsHelper
  def stored_mode_checked?(mission_request)
    return true if mission_request.new_record?

    mission_request.reason.present?
  end

  def form_label_class_mission_request
    case action_name
    when "new", "create"  then "form-label text-success fs-5 fw-bold fst-italic"
    when "edit", "update" then "form-label text-warning fs-5 fw-bold fst-italic"
    else                       "form-label fs-5 fw-bold fst-italic"
    end
  end

  def form_submit_label_mission_request
    case action_name
    when "new", "create"  then "Crea Richiesta Missione"
    when "edit", "update" then "Aggiorna Richiesta Missione"
    else                       "Salva"
    end
  end

  def form_submit_accent_mission_request
    case action_name
    when "new", "create"  then "btn btn-success"
    when "edit", "update" then "btn btn-warning"
    else                       "btn btn-primary"
    end
  end

  def form_hr_mission_request
    case action_name
    when "new", "create"  then "text-success"
    when "edit", "update" then "text-warning"
    else                       "text-primary"
    end
  end

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
