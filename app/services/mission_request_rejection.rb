class MissionRequestRejection
  def self.call(mission_request:, rejection_motivation:)
    new(mission_request, rejection_motivation).call
  end

  def initialize(mission_request, rejection_motivation)
    @mission_request = mission_request
    @rejection_motivation = rejection_motivation
  end

  def call
    if mission_request.update(request_approved: false, rejection_motivation: rejection_motivation)
      MissionRequestMailer.rejected(mission_request).deliver_later
    end
    mission_request
  end

  private

  attr_reader :mission_request, :rejection_motivation
end
