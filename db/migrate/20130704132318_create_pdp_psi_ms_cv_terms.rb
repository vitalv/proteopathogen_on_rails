class CreatePdpPsiMsCvTerms < ActiveRecord::Migration
  def change
    create_table :pdp_psi_ms_cv_terms do |t|

      t.timestamps
    end
  end
end
