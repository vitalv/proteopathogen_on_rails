class ProteinDetectionHypothesisPsiMsCvTermsToPdhPsiMsCvTerms < ActiveRecord::Migration
  def change
    rename_table :protein_detection_hypothesis_psi_ms_cv_terms, :pdh_psi_ms_cv_terms
  end
end
