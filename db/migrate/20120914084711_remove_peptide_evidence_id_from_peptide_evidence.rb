class RemovePeptideEvidenceIdFromPeptideEvidence < ActiveRecord::Migration
  def change
    remove_column :peptide_evidences, :peptide_evidence_id
  end

end
