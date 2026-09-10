# frozen_string_literal: true

# A reimbursement is strictly personal: not even an administrator reaches the
# ones belonging to somebody else through the front office.
class ReimbursementPolicy < OwnedRecordPolicy
  def print?
    true
  end
end
