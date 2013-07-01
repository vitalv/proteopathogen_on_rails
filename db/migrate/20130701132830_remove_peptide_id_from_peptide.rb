class RemovePeptideIdFromPeptide < ActiveRecord::Migration
  def up
   remove_column :peptides, :peptide_id
  end
  def down
    add_column :peptide_id, :peptides, :string
  end
end
