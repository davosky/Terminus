require "administrate/base_dashboard"

class PlaceDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    position: Field::Number,
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    position
    user
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    position
    user
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    position
    user
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(place)
    place.name
  end
end
