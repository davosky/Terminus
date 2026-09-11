class AddRequestedToHolidays < ActiveRecord::Migration[8.1]
  def change
    add_column :holidays, :requested, :boolean, default: false, null: false
  end
end
