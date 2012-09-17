class ProteinHypothesisPepevidenceJoinTable < ActiveRecord::Migration
  def change
    create_table :protein_hypothesis_pepevidence_join_table, :id => false do |t|
      t.integer :protein_detection_hypothesis_id
      t.integer :peptide_evidence_id
    end
  end
end
