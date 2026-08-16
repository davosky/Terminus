class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :producer
      t.string :licence_plate
      t.decimal :cost_per_km, precision: 8, scale: 2, default: "0.0"
      t.integer :position
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
