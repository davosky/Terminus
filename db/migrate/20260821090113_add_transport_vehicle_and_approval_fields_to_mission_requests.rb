class AddTransportVehicleAndApprovalFieldsToMissionRequests < ActiveRecord::Migration[8.1]
  def up
    add_reference :mission_requests, :transport, foreign_key: true
    add_reference :mission_requests, :vehicle, foreign_key: true
    add_column :mission_requests, :request_approved, :boolean
    add_column :mission_requests, :rejection_motivation, :text

    default_transport_id = execute("SELECT id FROM transports ORDER BY id LIMIT 1").first&.fetch("id")
    if default_transport_id
      execute("UPDATE mission_requests SET transport_id = #{default_transport_id} WHERE transport_id IS NULL")
    end

    change_column_null :mission_requests, :transport_id, false
  end

  def down
    remove_column :mission_requests, :rejection_motivation
    remove_column :mission_requests, :request_approved
    remove_reference :mission_requests, :vehicle
    remove_reference :mission_requests, :transport
  end
end
