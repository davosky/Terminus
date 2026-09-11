require "administrate/base_dashboard"

class PathDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    lenght: Field::Number.with_options(decimals: 2),
    highway_cost: Field::Number.with_options(decimals: 2),
    position: Field::Number,
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    lenght
    highway_cost
    user
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    lenght
    highway_cost
    position
    user
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    lenght
    highway_cost
    position
    user
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(path)
    path.name
  end
end
