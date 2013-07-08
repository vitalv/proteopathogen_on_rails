class ChangeProteinDetectionIdTypeToIntInSpectrumIdentificationLists < ActiveRecord::Migration
  def change
    change_column :spectrum_identification_lists, :protein_detection_id, :integer
  end
end
