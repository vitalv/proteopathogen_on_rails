class DropProteinDetectionHypothesisPeptideEvidences < ActiveRecord::Migration
  def up
    drop_table :protein_hypothesis_peptide_evidences
  end

  def down
    create_table :protein_hypothesis_peptide_evidences, :id => false do |t|
      t.integer :protein_hypothesis_id
      t.integer :peptide_evidence_id
    end
  end
end
