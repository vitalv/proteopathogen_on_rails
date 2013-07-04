class CreateProteinDetectionProtocols < ActiveRecord::Migration
  def change
    create_table :protein_detection_protocols do |t|
      t.references :protein_detection
      t.string :pdp_id
      t.string :name
    end
    add_index :protein_detection_protocols, :protein_detection_id
  end
end
