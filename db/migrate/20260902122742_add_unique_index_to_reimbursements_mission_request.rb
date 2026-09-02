class AddUniqueIndexToReimbursementsMissionRequest < ActiveRecord::Migration[8.1]
  # One approved mission request maps to at most one auto-generated reimbursement.
  # A partial unique index makes that a database guarantee, so concurrent /
  # double-submitted approvals can't create a second reimbursement for the same
  # request even if both pass the pending? check.
  def up
    remove_index :reimbursements, name: "index_reimbursements_on_mission_request_id"
    add_index :reimbursements, :mission_request_id,
              unique: true,
              where: "mission_request_id IS NOT NULL",
              name: "index_reimbursements_on_mission_request_id"
  end

  def down
    remove_index :reimbursements, name: "index_reimbursements_on_mission_request_id"
    add_index :reimbursements, :mission_request_id,
              name: "index_reimbursements_on_mission_request_id"
  end
end
