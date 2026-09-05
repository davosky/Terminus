# Right panel of a printed reimbursement: the expense breakdown, signed by the
# claimant and countersigned by the confirmator who authorises the payment.
class ExpenseSheetPanel < ReimbursementPanel
  INSTITUTE_TOP = 54.5
  SUMMARY_TOP = 62.3
  DISTANCE_TOP = 75.3
  DISTANCE_RULE_TOP = 81.5
  TABLE_TOP = 85.5
  ROW_HEIGHT = 5.25
  TABLE_WIDTH = 64
  DIVIDER_X = 26
  VALUE_X = 32
  TABLE_RULE_TOP = 129.0
  CLAIMANT_LABEL_TOP = 137.5
  CLAIMANT_SIGNATURE_TOP = 145.0
  CLAIMANT_RULE_TOP = 158.0
  PAYMENT_LABEL_TOP = 164.5
  PAYMENT_SIGNATURE_TOP = 172.5
  PAYMENT_RULE_TOP = 187.5
  FOOTER_RULE_LENGTH = 100

  def draw
    line(INSTITUTE_TOP, [ bold(user.institute) ], size: HEADING_SIZE)
    draw_summary
    draw_table
    draw_signatures
  end

  private

  def draw_summary
    line(SUMMARY_TOP, [ plain("Rimborso spese di:    "), bold(full_name) ])
    line(SUMMARY_TOP + LINE_HEIGHT, [ plain("Percorso:    "), bold(reimbursement.display_path) ])
    line(DISTANCE_TOP, distance_segments)
    dashed_line(DISTANCE_RULE_TOP, FOOTER_RULE_LENGTH)
  end

  def distance_segments
    [ plain("Lunghezza:    "), bold("#{decimal(reimbursement.display_path_lenght)} Km"),
      plain("    Costo al Km:    "), bold("#{decimal(reimbursement.vehicle&.cost_per_km)} €"),
      plain("    Totale:    "), bold("#{decimal(km_cost)} €") ]
  end

  def draw_table
    top = TABLE_TOP
    expense_rows.each do |label, amount|
      draw_row(top, label, amount)
      top += ROW_HEIGHT
    end
    pdf.stroke_vertical_line(y(TABLE_TOP), y(top), at: x(DIVIDER_X))
    draw_total(top)
  end

  def expense_rows
    [ [ "Vitto:", reimbursement.food_cost ], [ "Alloggio:", reimbursement.room_cost ],
      [ "Ticket:", reimbursement.ticket_cost ], [ "Varie:", reimbursement.generic_cost ],
      [ "Autostrada:", reimbursement.display_highway_cost ],
      [ "Parcheggio:", reimbursement.parking_cost ], [ "Costo Km Totali:", km_cost ] ]
  end

  def draw_row(top, label, amount)
    line(top + 0.6, [ plain(label) ])
    line(top + 0.6, [ plain(euro(amount)) ], indent: VALUE_X) unless amount.to_d.zero?
    pdf.stroke_horizontal_line(x(0), x(TABLE_WIDTH), at: y(top + ROW_HEIGHT))
  end

  def draw_total(top)
    line(top + 0.6, [ bold("Totale:") ])
    line(top + 0.6, [ bold(euro(reimbursement.total_amount)) ], indent: VALUE_X)
  end

  def draw_signatures
    dashed_line(TABLE_RULE_TOP, WIDTH)
    line(CLAIMANT_LABEL_TOP, [ plain("Firma del richiedente"), plain("            Data    "),
                               bold(date(reimbursement.reimbursement_date)) ])
    signature(CLAIMANT_SIGNATURE_TOP, user.user_signature)
    dashed_line(CLAIMANT_RULE_TOP, FOOTER_RULE_LENGTH)
    line(PAYMENT_LABEL_TOP, [ bold(user.confirmator_presentation), plain(" autorizza il pagamento:") ])
    signature(PAYMENT_SIGNATURE_TOP, user.confirmator_signature)
    dashed_line(PAYMENT_RULE_TOP, FOOTER_RULE_LENGTH)
  end

  # Mirrors ReimbursementTotalCalculator: only a private vehicle is reimbursed
  # per kilometre, so every other transport prints a zero mileage cost.
  def km_cost
    return 0 unless reimbursement.transport&.name == ReimbursementTotalCalculator::PRIVATE_VEHICLE_NAME

    (reimbursement.display_path_lenght || 0) * (reimbursement.vehicle&.cost_per_km || 0)
  end
end
