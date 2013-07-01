class RenamePeptideSequencesIdToPeptideSequenceIdColumnsInPeptideEvidence < ActiveRecord::Migration
  def up
    remove_column :peptide_evidences, :peptide_sequences_id
    change_table :peptide_evidences do |t|
      t.references :peptide_sequence
    end      
  end  
  def down
  end
end
