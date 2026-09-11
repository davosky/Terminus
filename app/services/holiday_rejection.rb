class HolidayRejection
  def self.call(holiday:, rejection_motivation:)
    new(holiday, rejection_motivation).call
  end

  def initialize(holiday, rejection_motivation)
    @holiday = holiday
    @rejection_motivation = rejection_motivation
  end

  def call
    if holiday.update(request_approved: false, rejection_motivation: rejection_motivation)
      HolidayMailer.rejected(holiday).deliver_later
      holiday.refresh_live_pages
    end
    holiday
  end

  private

  attr_reader :holiday, :rejection_motivation
end
