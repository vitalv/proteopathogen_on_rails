class RemoveMissedCleavegesFromPeptideEvidence < ActiveRecord::Migration
  def up
    remove_column :peptide_evidences, :missed_cleavages
  end

  def down
    add_column :peptide_evidences, :missed_cleavages
  end
end
