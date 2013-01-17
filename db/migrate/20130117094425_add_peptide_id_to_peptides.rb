class AddPeptideIdToPeptides < ActiveRecord::Migration
  def change
    add_column :peptides, :peptide_id, :string
  end
end
