class DropTableSiiPeptideEvidences < ActiveRecord::Migration
  def up
    drop_table :sii_peptide_evidences
  end

  def down
    create_table :sii_peptide_evidences, :id => false do |t|
      t.integer :spectrum_identification_item_id
      t.integer :peptide_evidence_id
    end
  end
end
