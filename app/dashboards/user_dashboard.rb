require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
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
    holiday_requesting_user: Field::Boolean,
    payroll: Field::Boolean,
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

  COLLECTION_ATTRIBUTES = %i[
    id
    username
    first_name
    last_name
    admin
  ].freeze

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
    holiday_requesting_user
    payroll
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
    holiday_requesting_user
    payroll
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

  COLLECTION_FILTERS = {}.freeze

  def display_resource(user)
    "#{user.username} (#{user.first_name} #{user.last_name})"
  end
end
