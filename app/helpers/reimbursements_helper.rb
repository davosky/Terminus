module ReimbursementsHelper
  def stored_mode_checked?(reimbursement)
    return true if reimbursement.new_record?

    reimbursement.reason.present?
  end

  def form_label_class_reimbursement
    case action_name
    when "new", "create"  then "form-label text-success fs-5 fw-bold fst-italic"
    when "edit", "update" then "form-label text-warning fs-5 fw-bold fst-italic"
    else                       "form-label fs-5 fw-bold fst-italic"
    end
  end

  def form_submit_label_reimbursement
    case action_name
    when "new", "create"  then "Crea Rimborso Spese"
    when "edit", "update" then "Aggiorna Rimborso Spese"
    else                       "Salva"
    end
  end

  def form_submit_accent_reimbursement
    case action_name
    when "new", "create"  then "btn btn-success"
    when "edit", "update" then "btn btn-warning"
    else                       "btn btn-primary"
    end
  end

  def form_hr_reimbursement
    case action_name
    when "new", "create"  then "text-success"
    when "edit", "update" then "text-warning"
    else                       "text-primary"
    end
  end
end
