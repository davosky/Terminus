class VehicleResource < Madmin::Resource
  attribute :id, form: false
  attribute :producer, index: true
  attribute :name, index: true
  attribute :licence_plate, index: true
  attribute :power, :select, collection: Vehicle::POWERS
  attribute :cost_per_km
  attribute :position, index: true
  attribute :user, field: UserCodeField, index: true
  attribute :created_at, form: false
  attribute :updated_at, form: false

  def self.display_name(record) = record.full_name
end
