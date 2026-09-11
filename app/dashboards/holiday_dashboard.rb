require "administrate/base_dashboard"

class HolidayDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    start_date: Field::Date,
    end_date: Field::Date,
    reason: Field::String,
    requested: Field::Boolean,
    request_approved: Field::Boolean,
    rejection_motivation: Field::Text,
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    start_date
    end_date
    user
    request_approved
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    start_date
    end_date
    reason
    requested
    request_approved
    rejection_motivation
    user
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    start_date
    end_date
    reason
    requested
    request_approved
    rejection_motivation
    user
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(holiday)
    "Ferie #{I18n.l(holiday.start_date)} - #{I18n.l(holiday.end_date)}"
  end
end
