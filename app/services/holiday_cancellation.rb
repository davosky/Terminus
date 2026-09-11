class HolidayCancellation
  def self.call(holiday:)
    new(holiday).call
  end

  def initialize(holiday)
    @holiday = holiday
  end

  # Row lock + re-check, as in HolidayApproval: a request a director approves in
  # the same instant stays put. A pending request has already reached the
  # directors by mail, so they are told it is withdrawn.
  def call
    withdrawn_request = false

    holiday.with_lock do
      next if holiday.locked?

      withdrawn_request = holiday.requested?
      holiday.destroy!
    end

    holiday.refresh_director_pages if holiday.destroyed?
    notify_directors if withdrawn_request
    holiday
  end

  private

  attr_reader :holiday

  # The job runs after the row is gone, so the mail gets plain values, not the record.
  def notify_directors
    details = { requester: holiday.user.full_name, start_date: holiday.start_date,
                end_date: holiday.end_date, reason: holiday.display_reason }

    holiday.candidate_validators.find_each do |director|
      HolidayMailer.cancelled(director, details).deliver_later
    end
  end
end
