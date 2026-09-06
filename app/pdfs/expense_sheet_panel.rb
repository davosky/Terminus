# Right panel of a printed reimbursement: the expense breakdown, signed by the
# claimant and countersigned by the confirmator who authorises the payment.
class ExpenseSheetPanel < ReimbursementPanel
  CARD_TOP = 35.73
  CARD_HEIGHT = 83.82
  CONTENT_X = 7.8
  INSTITUTE_TOP = 41.39
  SUMMARY_TOP = 49.18
  DISTANCE_TOP = 65.56
  DISTANCE_RULE_TOP = 72.88
  RULE_LENGTH = 100.81
  TABLE_TOP = 74.93
  ROW_HEIGHT = 5.14
  TABLE_WIDTH = 61.91
  DIVIDER_X = 23.6
  VALUE_X = 30.2
  SIGNATURE_CARD_TOP = 128.05
  SIGNATURE_CARD_HEIGHT = 70.02
  SIGNATURE_X = 5.01
  CLAIMANT_LABEL_TOP = 130.33
  CLAIMANT_SIGNATURE_TOP = 140.78
  DATE_TOP = 155.71
  DATE_X = 16.44
  CLAIMANT_RULE_TOP = 164.56
  PAYMENT_LABEL_TOP = 167.33
  PAYMENT_SIGNATURE_TOP = 181.98

  def draw
    card(CARD_TOP, CARD_HEIGHT)
    card(SIGNATURE_CARD_TOP, SIGNATURE_CARD_HEIGHT)
    line(INSTITUTE_TOP, [ institute ], size: HEADING_SIZE, indent: CONTENT_X)
    draw_summary
    draw_table
    draw_signatures
  end

  private

  # The path goes on a line of its own: it is the longest value of the sheet.
  def draw_summary
    line(SUMMARY_TOP, [ italic("Rimborso spese di:    "), bold(full_name) ], indent: CONTENT_X)
    line(SUMMARY_TOP + LINE_HEIGHT, [ italic("Percorso:") ], indent: CONTENT_X)
    line(SUMMARY_TOP + 2 * LINE_HEIGHT, [ bold(reimbursement.display_path) ], indent: CONTENT_X)
    line(DISTANCE_TOP, distance_segments, indent: CONTENT_X)
    dashed_line(DISTANCE_RULE_TOP, RULE_LENGTH, indent: CONTENT_X)
  end

  def distance_segments
    [ plain("Lunghezza:    "), bold("#{decimal(reimbursement.display_path_lenght)} Km"),
      plain("    Costo al Km:    "), bold("#{decimal(reimbursement.vehicle&.cost_per_km)} €"),
      plain("    Totale:    "), bold("#{decimal(km_cost)} €") ]
  end

  def draw_table
    top = TABLE_TOP
    pdf.line_width 0.1.mm
    expense_rows.each do |label, amount|
      draw_row(top, label, amount)
      top += ROW_HEIGHT
    end
    pdf.stroke_vertical_line(y(TABLE_TOP), y(top), at: x(CONTENT_X + DIVIDER_X))
    pdf.line_width 0.2.mm
    draw_total(top)
  end

  def expense_rows
    [ [ "Vitto:", reimbursement.food_cost ], [ "Alloggio:", reimbursement.room_cost ],
      [ "Ticket:", reimbursement.ticket_cost ], [ "Varie:", reimbursement.generic_cost ],
      [ "Autostrada:", reimbursement.display_highway_cost ],
      [ "Parcheggio:", reimbursement.parking_cost ], [ "Costo Km Totali:", km_cost ] ]
  end

  def draw_row(top, label, amount)
    line(top + 0.6, [ italic(label) ], indent: CONTENT_X)
    line(top + 0.6, [ plain(euro(amount)) ], indent: CONTENT_X + VALUE_X) unless amount.to_d.zero?
    pdf.stroke_horizontal_line(x(CONTENT_X), x(CONTENT_X + TABLE_WIDTH), at: y(top + ROW_HEIGHT))
  end

  def draw_total(top)
    line(top + 0.6, [ bold("Totale:") ], indent: CONTENT_X)
    line(top + 0.6, [ bold(euro(reimbursement.total_amount)) ], indent: CONTENT_X + VALUE_X)
  end

  def draw_signatures
    line(CLAIMANT_LABEL_TOP, [ italic("Firma del richiedente") ], indent: SIGNATURE_X)
    signature(CLAIMANT_SIGNATURE_TOP, user.user_signature, indent: SIGNATURE_X)
    date_column(DATE_TOP, reimbursement.reimbursement_date, label_x: SIGNATURE_X, value_x: DATE_X)
    dashed_line(CLAIMANT_RULE_TOP, RULE_LENGTH, indent: SIGNATURE_X)
    line(PAYMENT_LABEL_TOP, [ bold(user.confirmator_presentation) ], indent: SIGNATURE_X)
    line(PAYMENT_LABEL_TOP + LINE_HEIGHT, [ italic("autorizza il pagamento:") ], indent: SIGNATURE_X)
    signature(PAYMENT_SIGNATURE_TOP, user.confirmator_signature, indent: SIGNATURE_X)
  end

  # Mirrors ReimbursementTotalCalculator: only a private vehicle is reimbursed
  # per kilometre, so every other transport prints a zero mileage cost.
  def km_cost
    return 0 unless reimbursement.transport&.name == ReimbursementTotalCalculator::PRIVATE_VEHICLE_NAME

    (reimbursement.display_path_lenght || 0) * (reimbursement.vehicle&.cost_per_km || 0)
  end
end
