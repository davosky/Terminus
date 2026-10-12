class CreatePlaces < ActiveRecord::Migration[8.1]
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.integer :position, null: false
      t.integer :user_code, null: false

      t.timestamps
    end

    add_index :places, :user_code
    add_foreign_key :places, :users, column: :user_code, primary_key: :user_code
  end
end
