# Left panel of a printed reimbursement: the mission sheet authorising the trip,
# signed by the validator.
class MissionSheetPanel < ReimbursementPanel
  INSTITUTE_TOP = 54.5
  AUTHORISATION_TOP = 62.3
  TRANSPORT_TOP = 75.1
  SIGNATURE_LABEL_TOP = 102.5
  SIGNATURE_TOP = 112.5
  SIGNATURE_RULE_TOP = 127.0
  SIGNATURE_RULE_LENGTH = 39

  def draw
    line(INSTITUTE_TOP, [ bold(user.institute) ], size: HEADING_SIZE)
    draw_authorisation
    draw_transport
    draw_signature
  end

  private

  def draw_authorisation
    @top = AUTHORISATION_TOP
    advance([ plain("#{user.validator_presentation} di "),
              bold("#{user.institute} #{user.validator}"), plain(" autorizza:") ])
    advance([ bold(full_name), plain(" alla missione con il seguente mezzo di trasporto:") ])
  end

  def draw_transport
    @top = TRANSPORT_TOP
    advance([ bold(reimbursement.transport.name) ])
    advance(vehicle_segments) if reimbursement.vehicle
    advance([ plain("Luogo della Missione: #{reimbursement.display_place}") ])
    advance([ plain("Motivo del viaggio: "), bold(reimbursement.display_reason) ])
    advance(travel_dates_segments)
  end

  def vehicle_segments
    vehicle = reimbursement.vehicle
    [ plain("#{vehicle.producer} #{vehicle.name} con targa: "), bold(vehicle.licence_plate) ]
  end

  def travel_dates_segments
    [ plain("Partenza il: "), bold(date(reimbursement.departure_date)),
      plain("    Rientro il: "), bold(date(reimbursement.return_date)) ]
  end

  def draw_signature
    line(SIGNATURE_LABEL_TOP, [ plain("Firma de    #{user.validator_presentation}"),
                                plain("            Data    "), bold(date(reimbursement.request_date)) ])
    signature(SIGNATURE_TOP, user.validator_signature)
    dashed_line(SIGNATURE_RULE_TOP, SIGNATURE_RULE_LENGTH)
  end

  def advance(segments)
    line(@top, segments)
    @top += LINE_HEIGHT
  end
end
