class RenameColumnsInPeptideHypothesis < ActiveRecord::Migration
  def up
    remove_column :peptide_hypotheses, :peptide_evidence_id
    remove_column :peptide_hypotheses, :spectrum_identification_item_id
    change_table :peptide_hypotheses do |t|
      t.references :peptide_spectrum_assignment
    end      
  end 

  def down
  
  end
end
