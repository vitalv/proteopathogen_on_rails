class CreateProteinHypothesisPepevidenceJoinTable < ActiveRecord::Migration
  def change
    create_table :protein_hypothesis_pepevidence_join_table, :id => false do |t|
      t.integer :protein_detection_hypothesis_id
      t.integer :peptide_evidence_id
    end
    add_index(:protein_hypothesis_pepevidence_join_table, [:protein_detection_hypothesis_id, :peptide_evidence_id], :name => 'index_proteinhypothesis_pepevidence')
  end
end
