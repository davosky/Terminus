class HolidayApproval
  def self.call(holiday:)
    new(holiday).call
  end

  def initialize(holiday)
    @holiday = holiday
  end

  # Row lock + re-check: a double click, or two directors at once, must not
  # approve twice or send two mails.
  def call
    approved = false

    holiday.with_lock do
      next unless holiday.pending?

      holiday.update!(request_approved: true)
      approved = true
    end

    if approved
      HolidayMailer.approved(holiday).deliver_later
      holiday.refresh_director_pages
    end
    holiday
  end

  private

  attr_reader :holiday
end
