class RemoveMzidScopePeptideIdFromPeptides < ActiveRecord::Migration
  def change
    remove_column :peptides, :mzid_scope_peptide_id
  end

end
