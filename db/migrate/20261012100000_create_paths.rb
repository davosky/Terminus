class CreatePaths < ActiveRecord::Migration[8.1]
  def change
    create_table :paths do |t|
      t.string :name, null: false
      t.decimal :lenght, precision: 8, scale: 2, null: false
      t.decimal :highway_cost, precision: 8, scale: 2, null: false, default: 0
      t.integer :position, null: false
      t.integer :user_code, null: false

      t.timestamps
    end

    add_index :paths, :user_code
    add_foreign_key :paths, :users, column: :user_code, primary_key: :user_code
  end
end
