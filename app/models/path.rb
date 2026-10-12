class Path < ApplicationRecord
  belongs_to :user, foreign_key: :user_code, primary_key: :user_code

  validates :name, presence: true
  validates :lenght, numericality: { greater_than: 0, less_than: 1_000_000 }
  validates :highway_cost, numericality: { greater_than_or_equal_to: 0, less_than: 1_000_000 }
  validates :position, numericality: { only_integer: true, greater_than: 0 }

  scope :ordered, -> { order(:position, :name) }

  # Optional in the form: an empty highway cost means no toll
  def highway_cost=(value)
    super(value.presence || 0)
  end
end
