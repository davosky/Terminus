class Path < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :lenght, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :highway_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position) }
end
