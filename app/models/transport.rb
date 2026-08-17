class Transport < ApplicationRecord
  PROTECTED_NAMES = [ "Veicolo Aziendale", "Veicolo Privato" ].freeze

  belongs_to :user

  validates :name, presence: true

  scope :ordered, -> { order(:position) }

  def protected_record?
    PROTECTED_NAMES.include?(name)
  end
end
