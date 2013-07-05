class CreatePdpPsiMsCvTerms < ActiveRecord::Migration
  def change
    create_table :pdp_psi_ms_cv_terms do |t|
      t.references :protein_detection_protocol
      t.string :psi_ms_cv_term_accession
      t.string :value
    end
    add_index :pdp_psi_ms_cv_terms, :protein_detection_protocol_id
  end
end
