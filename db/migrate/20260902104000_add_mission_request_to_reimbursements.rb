class AddMissionRequestToReimbursements < ActiveRecord::Migration[8.1]
  def change
    add_reference :reimbursements, :mission_request,
                  null: true,
                  index: true,
                  foreign_key: { on_delete: :nullify }
  end
end
