class RemovePeptideIdFromSpectrumIdentificationItems < ActiveRecord::Migration
  def up
   remove_column :spectrum_identification_items, :peptide_id
  end
  def down
    change_table :spectrum_identification_items do |t|
      t.references :peptide
    end
  end
end
