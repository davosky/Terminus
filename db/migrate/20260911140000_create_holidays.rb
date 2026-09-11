class CreateHolidays < ActiveRecord::Migration[8.1]
  def change
    create_table :holidays do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :reason
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
