class ChangeDbSequenceRef2DbSequenceIdInPeptideEvidences < ActiveRecord::Migration

  def up
    change_table :peptide_evidences do |t|
      t.remove :db_sequence_ref
      t.references :db_sequence
    end
  end
  
  def down
    change_table :peptide_evidences do |t|
      t.remove :db_sequence_id
      t.string :db_sequence_ref
    end
  end
  
end
