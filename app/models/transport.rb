class Transport < ApplicationRecord
  belongs_to :user, foreign_key: :user_code, primary_key: :user_code

  validates :transport_name, presence: true
  validates :transport_position, numericality: { only_integer: true, greater_than: 0 }

  scope :ordered, -> { order(:transport_position, :transport_name) }
end
