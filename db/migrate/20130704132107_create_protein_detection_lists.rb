class CreateProteinDetectionLists < ActiveRecord::Migration
  def change
    create_table :protein_detection_lists do |t|
      t.references :protein_detection
      t.string :pdl_id
    end
    add_index :protein_detection_lists, :protein_detection_id
  end
end
