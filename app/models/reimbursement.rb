class Reimbursement < ApplicationRecord
  belongs_to :user
  belongs_to :reason, optional: true
  belongs_to :place, optional: true
  belongs_to :structure, optional: true
  belongs_to :path, optional: true
  belongs_to :transport
  belongs_to :vehicle, optional: true

  validates :name, presence: true, uniqueness: true
  validates :departure_date, presence: true
  validates :return_date, presence: true
  validates :request_date, presence: true
  validates :reimbursement_date, presence: true
  validate :stored_or_free_fields_present

  scope :ordered, -> { order(request_date: :desc) }

  def display_reason
    reason&.name || reason_fr
  end

  def display_place
    place&.name || place_fr
  end

  def display_structure
    structure&.name || structure_fr
  end

  def display_path
    path&.name || path_fr
  end

  def display_path_lenght
    path&.lenght || path_lenght_fr
  end

  def display_highway_cost
    path&.highway_cost || highway_cost_fr
  end

  private

  def stored_or_free_fields_present
    return if stored_fields_present? || free_fields_present?

    errors.add(:base, "Compilare tutti i campi in modalità \"Modelli Memorizzati\" oppure tutti i campi in modalità \"Campi Liberi\"")
  end

  def stored_fields_present?
    reason.present? && place.present? && structure.present? && path.present?
  end

  def free_fields_present?
    reason_fr.present? && place_fr.present? && structure_fr.present? && path_fr.present?
  end
end
