require "administrate/base_dashboard"

class ReimbursementDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    departure_date: Field::Date,
    return_date: Field::Date,
    request_date: Field::Date,
    reimbursement_date: Field::Date,
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
    parking_cost: Field::Number.with_options(decimals: 2),
    food_cost: Field::Number.with_options(decimals: 2),
    room_cost: Field::Number.with_options(decimals: 2),
    ticket_cost: Field::Number.with_options(decimals: 2),
    generic_cost: Field::Number.with_options(decimals: 2),
    total_amount: Field::Number.with_options(decimals: 2),
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    departure_date
    return_date
    user
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    departure_date
    return_date
    request_date
    reimbursement_date
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
    parking_cost
    food_cost
    room_cost
    ticket_cost
    generic_cost
    total_amount
    user
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    departure_date
    return_date
    request_date
    reimbursement_date
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
    parking_cost
    food_cost
    room_cost
    ticket_cost
    generic_cost
    user
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how reimbursements are displayed
  # across all pages of the admin dashboard.
  def display_resource(reimbursement)
    reimbursement.name
  end
end
