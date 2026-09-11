require "administrate/base_dashboard"

class MissionRequestDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    departure_date: Field::Date,
    return_date: Field::Date,
    request_date: Field::Date,
    reason: Field::BelongsTo,
    place: Field::BelongsTo,
    structure: Field::BelongsTo,
    path: Field::BelongsTo,
    reason_fr: Field::String,
    place_fr: Field::String,
    structure_fr: Field::String,
    path_fr: Field::String,
    path_lenght_fr: Field::Number.with_options(decimals: 2),
    highway_cost_fr: Field::Number.with_options(decimals: 2),
    transport: Field::BelongsTo,
    vehicle: Field::BelongsTo,
    request_approved: Field::Boolean,
    rejection_motivation: Field::Text,
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    departure_date
    return_date
    user
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    departure_date
    return_date
    request_date
    reason
    place
    structure
    path
    reason_fr
    place_fr
    structure_fr
    path_fr
    path_lenght_fr
    highway_cost_fr
    transport
    vehicle
    request_approved
    rejection_motivation
    user
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    departure_date
    return_date
    request_date
    reason
    place
    structure
    path
    reason_fr
    place_fr
    structure_fr
    path_fr
    path_lenght_fr
    highway_cost_fr
    transport
    vehicle
    request_approved
    rejection_motivation
    user
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(mission_request)
    mission_request.name
  end
end
