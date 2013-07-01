class RenamePeptideIdToPeptideSequenceIdColumnsInModifications < ActiveRecord::Migration
  def up
    remove_column :modifications, :peptide_id
    change_table :modifications do |t|
      t.references :peptide_sequence
    end      
  end 
  def down
  end
end
