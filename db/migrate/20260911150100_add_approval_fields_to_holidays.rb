class AddApprovalFieldsToHolidays < ActiveRecord::Migration[8.1]
  def change
    add_column :holidays, :request_approved, :boolean
    add_column :holidays, :rejection_motivation, :text
    add_index :holidays, :request_approved
  end
end
