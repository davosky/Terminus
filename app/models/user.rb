class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable

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
