class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :producer, null: false
      t.string :name, null: false
      t.string :licence_plate, null: false
      t.string :power, null: false
      t.decimal :cost_per_km, precision: 8, scale: 2, null: false, default: 0
      t.integer :position, null: false
      t.integer :user_code, null: false

      t.timestamps
    end

    add_index :vehicles, :user_code
    add_foreign_key :vehicles, :users, column: :user_code, primary_key: :user_code
  end
end
