class AddPeptideIdToSpectrumIdentificationItem < ActiveRecord::Migration
  def up
    change_table :spectrum_identification_items do |t|
      t.references :peptide
    end
  end
  def down
    change_table :spectrum_identification_items do |t|
      
    
    end
  end
end
