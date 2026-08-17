class CreatePaths < ActiveRecord::Migration[8.1]
  def change
    create_table :paths do |t|
      t.string :name
      t.decimal :lenght, precision: 8, scale: 2, default: "0.0"
      t.decimal :highway_cost, precision: 8, scale: 2, default: "0.0"
      t.integer :position
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
