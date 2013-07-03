class CreateProteinDetectionHypothesisPsiMsCvTerms < ActiveRecord::Migration
  def change
    create_table :protein_detection_hypothesis_psi_ms_cv_terms do |t|
      t.references :protein_detection_hypothesis
      t.string :psi_ms_cv_term_accession
      t.string :value
    end
  end
end
