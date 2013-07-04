class CreateProteinDetections < ActiveRecord::Migration
  def change
    create_table :protein_detections do |t|
      t.string :protein_detection_id
      t.string :name
    end
  end
end
