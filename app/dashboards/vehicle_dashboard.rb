require "administrate/base_dashboard"

class VehicleDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    producer: Field::String,
    licence_plate: Field::String,
    cost_per_km: Field::Number.with_options(decimals: 2),
    position: Field::Number,
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    producer
    licence_plate
    user
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    producer
    licence_plate
    cost_per_km
    position
    user
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    producer
    licence_plate
    cost_per_km
    position
    user
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(vehicle)
    "#{vehicle.name} (#{vehicle.licence_plate})"
  end
end
