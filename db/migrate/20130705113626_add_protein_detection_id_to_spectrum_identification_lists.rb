class AddProteinDetectionIdToSpectrumIdentificationLists < ActiveRecord::Migration
  def change
    add_column :spectrum_identification_lists, :protein_detection_id, :string  
  end
end
