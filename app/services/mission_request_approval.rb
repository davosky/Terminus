class MissionRequestApproval
  def self.call(mission_request:)
    new(mission_request).call
  end

  def initialize(mission_request)
    @mission_request = mission_request
  end

  def call
    reimbursement = nil

    # Row lock + re-check inside the transaction: two concurrent approvals (or a
    # double-submit before the redirect) can both pass the caller's pending?
    # check, but only the one that wins the lock creates the reimbursement. The
    # partial unique index on reimbursements.mission_request_id is the last line.
    mission_request.with_lock do
      if mission_request.pending?
        mission_request.update!(request_approved: true)
        reimbursement = ReimbursementFromMissionRequest.call(mission_request: mission_request)
      end
    end

    return Reimbursement.find_by(mission_request_id: mission_request.id) if reimbursement.nil?

    MissionRequestMailer.approved(mission_request, reimbursement).deliver_later
    reimbursement
  end

  private

  attr_reader :mission_request
end
