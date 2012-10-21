class CreateSirPsiMsCvTerms < ActiveRecord::Migration
  def change
    create_table :sir_psi_ms_cv_terms do |t|
      t.references :spectrum_identification_result, :null => false
      t.string :psi_ms_cv_term 
      t.string :value
    end
  end
end
