class MissionRequestApproval
  def self.call(mission_request:)
    new(mission_request).call
  end

  def initialize(mission_request)
    @mission_request = mission_request
  end

  def call
    mission_request.update!(request_approved: true)
    reimbursement = ReimbursementFromMissionRequest.call(mission_request: mission_request)
    MissionRequestMailer.approved(mission_request, reimbursement).deliver_later
    reimbursement
  end

  private

  attr_reader :mission_request
end
