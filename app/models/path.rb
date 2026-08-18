class Path < ApplicationRecord
  belongs_to :user
  has_many :mission_requests, dependent: :nullify

  validates :name, presence: true
  validates :lenght, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :highway_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position) }
end
