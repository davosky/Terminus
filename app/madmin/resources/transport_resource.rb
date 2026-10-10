class TransportResource < Madmin::Resource
  attribute :id, form: false
  attribute :transport_name, index: true
  attribute :transport_position, index: true
  attribute :locked, index: true
  attribute :user, field: UserCodeField, index: true
  attribute :created_at, form: false
  attribute :updated_at, form: false

  def self.display_name(record) = record.transport_name
end
