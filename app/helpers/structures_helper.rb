module StructuresHelper
  def form_label_class_structure
    case action_name
    when "new", "create"  then "form-label text-success fs-5 fw-bold fst-italic"
    when "edit", "update" then "form-label text-warning fs-5 fw-bold fst-italic"
    else                       "form-label fs-5 fw-bold fst-italic"
    end
  end

  def form_submit_label_structure
    case action_name
    when "new", "create"  then "Crea Struttura"
    when "edit", "update" then "Aggiorna Struttura"
    else                       "Salva"
    end
  end

  def form_submit_accent_structure
    case action_name
    when "new", "create"  then "btn btn-success"
    when "edit", "update" then "btn btn-warning"
    else                       "btn btn-primary"
    end
  end
end
