class CreateTransports < ActiveRecord::Migration[8.1]
  def change
    create_table :transports do |t|
      t.string :transport_name, null: false
      t.integer :transport_position, null: false
      t.boolean :locked, null: false, default: false
      t.integer :user_code, null: false

      t.timestamps
    end

    add_index :transports, :user_code
    add_foreign_key :transports, :users, column: :user_code, primary_key: :user_code
  end
end
