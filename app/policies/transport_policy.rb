# frozen_string_literal: true

# Locked transports can only be changed in Madmin
class TransportPolicy < OwnedRecordPolicy
  def update?
    super && !record.locked?
  end

  # The edit and confirm_destroy pages open for locked records too: they show the warning
  def edit?
    owner?
  end
end
