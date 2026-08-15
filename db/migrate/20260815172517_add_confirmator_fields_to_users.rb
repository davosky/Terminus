class AddConfirmatorFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :confirmator, :string
    add_column :users, :confirmator_presentation, :string
    add_column :users, :confirmator_signature, :string
  end
end
