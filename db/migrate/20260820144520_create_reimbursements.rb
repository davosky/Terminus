class CreateReimbursements < ActiveRecord::Migration[8.1]
  def change
    create_table :reimbursements do |t|
      t.string :name
      t.date :departure_date
      t.date :return_date
      t.date :request_date
      t.date :reimbursement_date
      t.references :reason, null: true, foreign_key: true
      t.references :place, null: true, foreign_key: true
      t.references :structure, null: true, foreign_key: true
      t.references :path, null: true, foreign_key: true
      t.string :reason_fr
      t.string :place_fr
      t.string :structure_fr
      t.string :path_fr
      t.decimal :path_lenght_fr, precision: 8, scale: 2, default: "0.0"
      t.decimal :highway_cost_fr, precision: 8, scale: 2, default: "0.0"
      t.references :transport, null: false, foreign_key: true
      t.references :vehicle, null: true, foreign_key: true
      t.decimal :parking_cost, precision: 8, scale: 2, default: "0.0"
      t.decimal :food_cost, precision: 8, scale: 2, default: "0.0"
      t.decimal :room_cost, precision: 8, scale: 2, default: "0.0"
      t.decimal :ticket_cost, precision: 8, scale: 2, default: "0.0"
      t.decimal :generic_cost, precision: 8, scale: 2, default: "0.0"
      t.decimal :total_amount, precision: 8, scale: 2, default: "0.0"
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :reimbursements, :name, unique: true
  end
end
