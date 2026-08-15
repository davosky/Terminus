class AddValidatorFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :validator, :string
    add_column :users, :validator_presentation, :string
    add_column :users, :validator_signature, :string
  end
end
