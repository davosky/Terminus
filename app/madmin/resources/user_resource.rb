class UserResource < Madmin::Resource
  attribute :id, form: false
  attribute :user_code, form: false, index: true
  attribute :username, index: true
  attribute :email
  attribute :password, :password, index: false, show: false
  attribute :first_name, index: true
  attribute :last_name, index: true
  attribute :gender, :select, collection: User::GENDERS
  attribute :region
  attribute :province
  attribute :institute
  attribute :office
  attribute :category
  attribute :admin, index: true
  attribute :manager
  attribute :payroll
  attribute :regular
  attribute :reimbursement_request
  attribute :failed_attempts, form: false
  attribute :locked_at
  attribute :created_at, form: false
  attribute :updated_at, form: false

  def self.display_name(record) = record.full_name
end
