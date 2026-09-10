module ApplicationHelper
  # Form chrome shared by every resource: green while creating, orange while
  # editing. The submit label takes its wording from the model's translation.
  def form_label_class
    "form-label #{form_accent_text_class} fs-5 fw-bold fst-italic".squish
  end

  def form_hr_class
    form_accent_text_class.presence || "text-primary"
  end

  def form_submit_accent
    case action_name
    when "new", "create"  then "btn btn-success"
    when "edit", "update" then "btn btn-warning"
    else                       "btn btn-primary"
    end
  end

  def form_submit_label(record)
    case action_name
    when "new", "create"  then "Crea #{record.model_name.human}"
    when "edit", "update" then "Aggiorna #{record.model_name.human}"
    else                       "Salva"
    end
  end

  def stored_mode_checked?(record)
    return true if record.new_record?

    record.reason.present?
  end

  private

  def form_accent_text_class
    case action_name
    when "new", "create"  then "text-success"
    when "edit", "update" then "text-warning"
    else                       ""
    end
  end
end
