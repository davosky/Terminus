class Vehicle < ApplicationRecord
  POWERS = %w[Diesel Benzina Ibrido Elettrico].freeze

  belongs_to :user, foreign_key: :user_code, primary_key: :user_code

  validates :producer, :name, :licence_plate, presence: true
  validates :power, inclusion: { in: POWERS }
  validates :cost_per_km, numericality: { greater_than_or_equal_to: 0, less_than: 1_000_000 }
  validates :position, numericality: { only_integer: true, greater_than: 0 }

  scope :ordered, -> { order(:position, :name) }

  def full_name
    "#{producer} #{name}"
  end
end
