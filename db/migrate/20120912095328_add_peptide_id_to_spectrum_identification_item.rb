class AddPeptideIdToSpectrumIdentificationItem < ActiveRecord::Migration
  def up
    change_table :spectrum_identification_items do |t|
      t.references :peptide
    end
  end
  def down
    remove_column :spectrum_identification_items, :peptide_id
  end
end
