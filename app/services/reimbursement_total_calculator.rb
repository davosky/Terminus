class ReimbursementTotalCalculator
  PRIVATE_VEHICLE_NAME = "Veicolo Privato"
  COMPANY_VEHICLE_NAME = "Veicolo Aziendale"

  def self.call(reimbursement:)
    new(reimbursement).call
  end

  def initialize(reimbursement)
    @reimbursement = reimbursement
  end

  def call
    stay_costs + transport_costs
  end

  private

  attr_reader :reimbursement

  def stay_costs
    reimbursement.food_cost + reimbursement.room_cost + reimbursement.ticket_cost + reimbursement.generic_cost
  end

  def transport_costs
    case reimbursement.transport&.name
    when PRIVATE_VEHICLE_NAME
      path_distance_cost + path_highway_cost + reimbursement.parking_cost
    when COMPANY_VEHICLE_NAME
      path_highway_cost + reimbursement.parking_cost
    else
      0
    end
  end

  def path_distance_cost
    (reimbursement.display_path_lenght || 0) * (reimbursement.vehicle&.cost_per_km || 0)
  end

  def path_highway_cost
    reimbursement.display_highway_cost || 0
  end
end
