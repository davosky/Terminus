class CreateStructures < ActiveRecord::Migration[8.1]
  def change
    create_table :structures do |t|
      t.string :name
      t.integer :position
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
