class Reason < ApplicationRecord
  belongs_to :user, foreign_key: :user_code, primary_key: :user_code

  validates :name, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }

  scope :ordered, -> { order(:position, :name) }
end
