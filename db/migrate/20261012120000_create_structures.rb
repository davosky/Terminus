class CreateStructures < ActiveRecord::Migration[8.1]
  def change
    create_table :structures do |t|
      t.string :name, null: false
      t.integer :position, null: false
      t.integer :user_code, null: false

      t.timestamps
    end

    add_index :structures, :user_code
    add_foreign_key :structures, :users, column: :user_code, primary_key: :user_code
  end
end
