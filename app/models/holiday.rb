class Holiday < ApplicationRecord
  include ApprovalDecision

  belongs_to :user

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_date, comparison: { less_than_or_equal_to: :end_date, message: "non può essere posteriore alla data di fine" },
                         if: -> { start_date && end_date }

  scope :ordered, -> { order(:start_date) }

  def display_reason
    reason.presence || "Ferie"
  end

  # Only requests lock once decided; holidays entered directly stay editable.
  def locked?
    requested? && !pending?
  end

  # A flagged employee's own holidays start as a pending request; everything
  # else (directors, unflagged users, a director entering them for someone) is approved at once.
  def submitted_by(creator)
    self.requested = user == creator && creator.requires_holiday_approval?
    self.request_approved = true unless requested?
    self
  end

  private

  # Holiday owners follow their own pages live too; mission request owners don't.
  def refresh_audience
    candidate_validators.to_a | [ user ]
  end
end
