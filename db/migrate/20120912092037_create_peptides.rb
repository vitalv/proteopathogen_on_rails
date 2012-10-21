class CreatePeptides < ActiveRecord::Migration
  def change
    create_table :peptides do |t|
      t.string :mzid_scope_peptide_id
      t.string :sequence
      t.string :molecular_weight
      t.string :isoelectric_point
      t.timestamps
    end
  end
end
