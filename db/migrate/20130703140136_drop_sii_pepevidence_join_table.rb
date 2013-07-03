class DropSiiPepevidenceJoinTable < ActiveRecord::Migration
  def up
    drop_table :sii_pepevidence_join_table
  end

  def down
    create_table :sii_pepevidence_join_table, :id => false do |t|
      t.integer :spectrum_identification_item_id
      t.integer :peptide_evidence_id
    end
  end
end
