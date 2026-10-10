# belongs_to :user through users.user_code: Madmin's own field only handles `<name>_id` keys
class UserCodeField < Madmin::Fields::BelongsTo
  def self.field_type
    "belongs_to"
  end

  def options_for_select(_record)
    User.order(:last_name, :first_name).map { |user| [ user.full_name, user.user_code ] }
  end

  def to_param
    :user_code
  end

  # No remote search: it would return ids instead of user codes
  def index_path(...)
  end
end
