class AddInstituteAndOfficeToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :institute, :string
    add_column :users, :office, :string
  end
end
