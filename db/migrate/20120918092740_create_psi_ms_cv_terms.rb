class CreatePsiMsCvTerms < ActiveRecord::Migration
  def change
    create_table :psi_ms_cv_terms do |t|
      t.string :accession
      t.string :name
    end
  end
end
