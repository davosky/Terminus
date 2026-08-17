class Place < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  scope :ordered, -> { order(:position) }
end
