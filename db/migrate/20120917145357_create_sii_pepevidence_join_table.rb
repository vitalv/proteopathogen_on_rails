class CreateSiiPepevidenceJoinTable < ActiveRecord::Migration
  def up
    create_table :sii_pepevidence_join_table, :id => false do |t|
      t.integer :spectrum_identification_item_id
      t.integer :peptide_evidence_id
    end
    add_index(:sii_pepevidence_join_table, [:spectrum_identification_item_id, :peptide_evidence_id], :name => 'index_sii_pepevidence')
  end

  def down
    drop_table :sii_pepevidence_join_table
  end
  
end
