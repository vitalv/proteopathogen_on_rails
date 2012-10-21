class AddPeptideIdToSpectrumIdentificationItem < ActiveRecord::Migration
  def change
    add_column :spectrum_identification_items, :peptide_id, :integer, :null => false
  end
end
