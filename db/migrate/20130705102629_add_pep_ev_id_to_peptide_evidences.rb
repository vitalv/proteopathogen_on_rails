class AddPepEvIdToPeptideEvidences < ActiveRecord::Migration
  def change
    add_column :peptide_evidences, :pepev_id, :string  
  end
end
