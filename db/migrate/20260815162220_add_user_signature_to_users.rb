class AddUserSignatureToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :user_signature, :string
  end
end
