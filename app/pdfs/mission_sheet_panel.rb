# Left panel of a printed reimbursement: the mission sheet authorising the trip,
# signed by the validator.
class MissionSheetPanel < ReimbursementPanel
  CARD_TOP = 51.25
  CARD_HEIGHT = 78.82
  CONTENT_X = 6.33
  INSTITUTE_TOP = 55.95
  AUTHORISATION_TOP = 63.74
  TRANSPORT_TOP = 89.14
  SIGNATURE_CARD_TOP = 135.57
  SIGNATURE_CARD_HEIGHT = 49.52
  SIGNATURE_LABEL_TOP = 141.25
  SIGNATURE_TOP = 152.01
  SIGNATURE_RULE_TOP = 169.55
  SIGNATURE_RULE_LENGTH = 100.72
  DATE_TOP = 175.86
  DATE_X = 17.6

  def draw
    card(CARD_TOP, CARD_HEIGHT)
    card(SIGNATURE_CARD_TOP, SIGNATURE_CARD_HEIGHT)
    line(INSTITUTE_TOP, [ institute ], size: HEADING_SIZE, indent: CONTENT_X)
    draw_authorisation
    draw_transport
    draw_signature
  end

  private

  # One value per line: a long institute, validator or full name pushes the
  # following lines down instead of running into them.
  def draw_authorisation
    @top = AUTHORISATION_TOP
    advance([ bold(user.validator_presentation), italic(" di") ])
    advance([ bold(user.institute) ])
    advance([ bold(user.validator), italic(" autorizza:") ])
    advance([ bold(full_name) ])
    advance([ italic("alla missione con il seguente mezzo di trasporto:") ])
  end

  def draw_transport
    @top = TRANSPORT_TOP
    advance([ bold(reimbursement.transport.name) ])
    advance(vehicle_segments) if reimbursement.vehicle
    advance([ italic("Luogo della Missione: "), bold(reimbursement.display_place) ])
    advance([ italic("Motivo del viaggio:") ])
    advance([ bold(reimbursement.display_reason) ])
    @top += LINE_HEIGHT
    advance(travel_dates_segments)
  end

  def vehicle_segments
    vehicle = reimbursement.vehicle
    [ bold("#{vehicle.producer} #{vehicle.name}"), italic(" con targa: "), bold(vehicle.licence_plate) ]
  end

  def travel_dates_segments
    [ italic("Partenza il: "), bold(date(reimbursement.departure_date)),
      italic("    Rientro il: "), bold(date(reimbursement.return_date)) ]
  end

  def draw_signature
    line(SIGNATURE_LABEL_TOP, [ italic("Firma de:    "), bold(user.validator_presentation) ],
      indent: CONTENT_X)
    signature(SIGNATURE_TOP, user.validator_signature, indent: CONTENT_X)
    dashed_line(SIGNATURE_RULE_TOP, SIGNATURE_RULE_LENGTH, indent: CONTENT_X)
    date_column(DATE_TOP, reimbursement.request_date, label_x: CONTENT_X, value_x: DATE_X)
  end

  def advance(segments)
    line(@top, segments, indent: CONTENT_X)
    @top += LINE_HEIGHT
  end
end
