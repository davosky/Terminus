module HolidaysHelper
  # Theme colours for the calendar, one per person on the director's team;
  # "light" is left out because it vanishes on the calendar's pale cells.
  HOLIDAY_COLORS = %w[primary success danger info warning dark secondary tertiary].freeze

  def holiday_badge_class(user, calendar_users)
    index = calendar_users.index(user) || 0
    "text-bg-#{HOLIDAY_COLORS[index % HOLIDAY_COLORS.size]}"
  end
end
