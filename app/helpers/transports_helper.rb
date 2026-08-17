module TransportsHelper
  def form_label_class_transport
    case action_name
    when "new", "create"  then "form-label text-success fs-5 fw-bold fst-italic"
    when "edit", "update" then "form-label text-warning fs-5 fw-bold fst-italic"
    else                       "form-label fs-5 fw-bold fst-italic"
    end
  end

  def form_submit_label_transport
    case action_name
    when "new", "create"  then "Crea Trasporto"
    when "edit", "update" then "Aggiorna Trasporto"
    else                       "Salva"
    end
  end

  def form_submit_accent_transport
    case action_name
    when "new", "create"  then "btn btn-success"
    when "edit", "update" then "btn btn-warning"
    else                       "btn btn-primary"
    end
  end
end
