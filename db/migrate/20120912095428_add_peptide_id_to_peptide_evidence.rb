class AddPeptideIdToPeptideEvidence < ActiveRecord::Migration
  def change
    change_column :peptide_evidences, :peptide_id, :integer, :null => false
  end
end
