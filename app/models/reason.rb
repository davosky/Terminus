class Reason < ApplicationRecord
  belongs_to :user
  has_many :mission_requests, dependent: :nullify

  validates :name, presence: true

  scope :ordered, -> { order(:position) }
end
