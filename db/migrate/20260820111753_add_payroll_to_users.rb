class AddPayrollToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :payroll, :boolean, default: false, null: false
  end
end
