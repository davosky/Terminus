class Transport < ApplicationRecord
  PROTECTED_NAMES = [ "Veicolo Aziendale", "Veicolo Privato" ].freeze

  belongs_to :user
  has_many :reimbursements, dependent: :restrict_with_error
  has_many :mission_requests, dependent: :restrict_with_error

  validates :name, presence: true

  scope :ordered, -> { order(:position) }

  def protected_record?
    PROTECTED_NAMES.include?(name)
  end
end
