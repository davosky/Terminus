class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable, :lockable

  has_many :vehicles
  has_many :transports
  has_many :reasons
  has_many :paths
  has_many :places
  has_many :structures
  has_many :mission_requests
  has_many :reimbursements
  has_many :holidays

  mount_uploader :user_signature, UserSignatureUploader
  mount_uploader :validator_signature, ValidatorSignatureUploader
  mount_uploader :confirmator_signature, ConfirmatorSignatureUploader

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # "Mario Rossi" → "M. Rossi", for tight spaces like the holiday calendar.
  def short_name
    initial = first_name.present? ? "#{first_name.first}." : nil
    [ initial, last_name ].compact_blank.join(" ").presence || username
  end

  def full_name
    [ first_name, last_name ].compact_blank.join(" ").presence || username
  end

  # Everyone sharing my region, province and institute, me included: the scope
  # a director works on. Empty while any of the three is blank.
  def colleagues
    return User.none if region.blank? || province.blank? || institute.blank?

    User.where(region: region, province: province, institute: institute)
  end

  def directors
    colleagues.where(manager: true)
  end

  # Whose holidays I see and may enter: myself, plus my colleagues if I direct them.
  def holiday_team
    User.where(id: [ id, *(manager? ? colleagues.ids : []) ])
  end

  # Only a flagged employee's own holidays wait for a director; directors and
  # unflagged users record theirs as already approved.
  def requires_holiday_approval?
    holiday_requesting_user? && !manager?
  end

  # Devise's :validatable module requires an email by default. Authentication
  # is username-based, so email stays optional here.
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
