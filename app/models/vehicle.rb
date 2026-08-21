class Vehicle < ApplicationRecord
  belongs_to :user
  has_many :reimbursements, dependent: :nullify
  has_many :mission_requests, dependent: :nullify

  validates :name, presence: true
  validates :producer, presence: true
  validates :licence_plate, presence: true
  validates :cost_per_km, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position) }
end
