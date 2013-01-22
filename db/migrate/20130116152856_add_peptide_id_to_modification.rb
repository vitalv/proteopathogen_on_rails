class AddPeptideIdToModification < ActiveRecord::Migration
  def change
    change_table :modifications do |t|
      t.references :peptide
    end
  end
end
