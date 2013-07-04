class CreateProteinDetectionLists < ActiveRecord::Migration
  def change
    create_table :protein_detection_lists do |t|
      t.references :protein_detection
    end
    add_index :protein_detection_lists, :protein_detection_id
  end
end
