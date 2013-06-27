class DropProteinDetectionHypothesisPepevidenceJointable < ActiveRecord::Migration
  def up
    drop_table :protein_hypothesis_pepevidence_join_table
  end

  def down
    create_table :protein_hypothesis_pepevidence_join_table, :id => false do |t|
      t.integer :protein_hypothesis_id
      t.integer :peptide_evidence_id
    end
  end
end
