require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    admin: Field::Boolean,
    email: Field::Email,
    category: Field::String,
    institute: Field::String,
    office: Field::String,
    first_name: Field::String,
    gender: Field::String,
    last_name: Field::String,
    manager: Field::Boolean,
    mission_requesting_user: Field::Boolean,
    province: Field::String,
    region: Field::String,
    regular: Field::Boolean,
    username: Field::String,
    user_signature: CarrierwaveField.with_options(download_path: :download_signature_admin_user_path),
    validator: Field::String,
    validator_presentation: Field::String,
    validator_signature: CarrierwaveField.with_options(download_path: :download_validator_signature_admin_user_path),
    confirmator: Field::String,
    confirmator_presentation: Field::String,
    confirmator_signature: CarrierwaveField.with_options(download_path: :download_confirmator_signature_admin_user_path),
    password: Field::Password,
    password_confirmation: Field::Password,
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
    username
    first_name
    last_name
    admin
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    username
    email
    first_name
    last_name
    gender
    region
    province
    category
    institute
    office
    admin
    manager
    regular
    mission_requesting_user
    user_signature
    validator
    validator_presentation
    validator_signature
    confirmator
    confirmator_presentation
    confirmator_signature
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    username
    email
    first_name
    last_name
    gender
    region
    province
    category
    institute
    office
    admin
    manager
    regular
    mission_requesting_user
    user_signature
    validator
    validator_presentation
    validator_signature
    confirmator
    confirmator_presentation
    confirmator_signature
    password
    password_confirmation
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

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  def display_resource(user)
    "#{user.username} (#{user.first_name} #{user.last_name})"
  end
end
