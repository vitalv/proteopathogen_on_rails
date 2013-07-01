class AddPeptideEvidenceIdToModifications < ActiveRecord::Migration
  def change
    change_table :modifications do |t|
      t.references :peptide_evidences
    end  
  end
end
