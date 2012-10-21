class CreateSiiPsiMsCvTerms < ActiveRecord::Migration
  def change
    create_table :sii_psi_ms_cv_terms do |t|
      t.references :spectrum_identification_item
      t.string :psi_ms_cv_term_accession
      t.string :value
      t.timestamps
    end
  end
end
