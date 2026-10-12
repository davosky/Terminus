class User < ApplicationRecord
  GENDERS = %w[M F A].freeze

  has_many :transports, foreign_key: :user_code, primary_key: :user_code
  has_many :vehicles, foreign_key: :user_code, primary_key: :user_code
  has_many :paths, foreign_key: :user_code, primary_key: :user_code
  has_many :places, foreign_key: :user_code, primary_key: :user_code

  devise :database_authenticatable, :validatable, :lockable

  normalizes :region, :province, with: ->(value) { value.strip.upcase }

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, :institute, :office, presence: true
  validates :gender, inclusion: { in: GENDERS }
  validates :region, format: { with: /\A[A-Z]{3}\z/ }
  validates :province, format: { with: /\A[A-Z]{2,3}\z/ }

  def full_name
    "#{first_name} #{last_name}"
  end
end
