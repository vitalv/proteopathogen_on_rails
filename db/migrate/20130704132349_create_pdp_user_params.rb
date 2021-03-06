class CreatePdpUserParams < ActiveRecord::Migration
  def change
    create_table :pdp_user_params do |t|
      t.references :protein_detection_protocol
      t.string :name
      t.string :value
    end
    add_index :pdp_user_params, :protein_detection_protocol_id
  end
end
