class CreateProteinDetectionHypotheses < ActiveRecord::Migration
  def change
    create_table :protein_detection_hypotheses do |t|
      t.references :peptide_evidence
      t.string :protein_detection_hypothesis_id
      t.string :pass_threshold
      t.string :name
    end
  end
end
