class ReimbursementFromMissionRequest
  def self.call(mission_request:)
    new(mission_request).call
  end

  def initialize(mission_request)
    @mission_request = mission_request
  end

  def call
    reimbursement = mission_request.user.reimbursements.build(copied_attributes)
    reimbursement.name = ReimbursementCodeGenerator.call(user: mission_request.user)
    reimbursement.reimbursement_date = ReimbursementDateGenerator.call(departure_date: reimbursement.departure_date)
    reimbursement.total_amount = ReimbursementTotalCalculator.call(reimbursement: reimbursement)
    reimbursement.save!
    reimbursement
  end

  private

  attr_reader :mission_request

  def copied_attributes
    {
      departure_date: mission_request.departure_date,
      return_date: mission_request.return_date,
      request_date: mission_request.request_date,
      transport_id: mission_request.transport_id,
      vehicle_id: mission_request.vehicle_id,
      reason_id: mission_request.reason_id,
      place_id: mission_request.place_id,
      structure_id: mission_request.structure_id,
      path_id: mission_request.path_id,
      reason_fr: mission_request.reason_fr,
      place_fr: mission_request.place_fr,
      structure_fr: mission_request.structure_fr,
      path_fr: mission_request.path_fr,
      path_lenght_fr: mission_request.path_lenght_fr,
      highway_cost_fr: mission_request.highway_cost_fr
    }
  end
end
