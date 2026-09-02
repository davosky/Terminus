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

  mount_uploader :user_signature, UserSignatureUploader
  mount_uploader :validator_signature, ValidatorSignatureUploader
  mount_uploader :confirmator_signature, ConfirmatorSignatureUploader

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # Devise's :validatable module requires an email by default. Authentication
  # is username-based, so email stays optional here.
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
