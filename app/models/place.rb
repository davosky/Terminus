class Place < ApplicationRecord
  belongs_to :user
  has_many :mission_requests
  has_many :reimbursements

  validates :name, presence: true

  scope :ordered, -> { order(:position) }
end
