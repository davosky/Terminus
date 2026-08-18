class AddMissionRequestingUserToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :mission_requesting_user, :boolean, default: false, null: false
  end
end
