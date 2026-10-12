class StructureResource < Madmin::Resource
  attribute :id, form: false
  attribute :name, index: true
  attribute :position, index: true
  attribute :user, field: UserCodeField, index: true
  attribute :created_at, form: false
  attribute :updated_at, form: false

  def self.display_name(record) = record.name
end
