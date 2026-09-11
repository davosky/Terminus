# Shared by MissionRequest and Holiday: request_approved is nil while pending,
# true once approved, false once rejected (which needs a motivation).
module ApprovalDecision
  extend ActiveSupport::Concern

  included do
    validates :rejection_motivation, presence: true, if: -> { request_approved == false }

    scope :pending, -> { where(request_approved: nil) }
    scope :approved, -> { where(request_approved: true) }
    scope :rejected, -> { where(request_approved: false) }
  end

  def pending?
    request_approved.nil?
  end

  def rejected?
    request_approved == false
  end

  def decision_label
    request_approved? ? "Approvata" : "Respinta"
  end

  def candidate_validators
    user.directors
  end

  # Tells every director who can see the record to reload their open pages on
  # its stream (:mission_requests / :holidays); the broadcast carries no data,
  # each page re-fetches through its own authorized controller.
  def refresh_director_pages
    candidate_validators.find_each { |director| Turbo::StreamsChannel.broadcast_refresh_to(director, model_name.plural.to_sym) }
  end
end
