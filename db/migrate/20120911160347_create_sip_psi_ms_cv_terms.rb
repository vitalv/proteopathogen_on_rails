class CreateSipPsiMsCvTerms < ActiveRecord::Migration
  def change
    create_table :sip_psi_ms_cv_terms do |t|
      t.references :spectrum_identification_protocol
      t.string :psi_ms_cv_term_accession
      t.string :value
      t.timestamps
    end
  end
end
