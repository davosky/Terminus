class ReimbursementDateGenerator
  def self.call(departure_date:)
    new(departure_date).call
  end

  def initialize(departure_date)
    @departure_date = departure_date
  end

  def call
    return nil unless departure_date

    date = departure_date.end_of_month
    date -= 1 until date.friday?
    date
  end

  private

  attr_reader :departure_date
end
