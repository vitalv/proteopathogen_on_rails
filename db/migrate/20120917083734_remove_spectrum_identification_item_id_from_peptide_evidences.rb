class RemoveSpectrumIdentificationItemIdFromPeptideEvidences < ActiveRecord::Migration
  def change
    remove_column :peptide_evidences, :spectrum_identification_item_id
  end
end
