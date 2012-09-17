class CreateProteinHypothesisPeptideEvidences < ActiveRecord::Migration
  def change
    create_table :protein_hypothesis_peptide_evidences do |t|
      t.references :peptide_evidence
      t.references :protein_detection_hypothesis
    end
  end
end
