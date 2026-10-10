# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.serial :user_code, null: false
      t.string :username, null: false
      t.string :email, null: false
      t.string :encrypted_password, null: false, default: ""
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :gender, null: false, limit: 1
      t.string :region, null: false, limit: 3
      t.string :province, null: false, limit: 3
      t.string :institute, null: false
      t.string :office, null: false
      t.string :category
      t.boolean :admin, null: false, default: false
      t.boolean :manager, null: false, default: false
      t.boolean :payroll, null: false, default: false
      t.boolean :regular, null: false, default: false
      t.boolean :reimbursement_request, null: false, default: false

      ## Lockable
      t.integer :failed_attempts, null: false, default: 0
      t.datetime :locked_at

      t.timestamps null: false
    end

    add_index :users, :user_code, unique: true
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
