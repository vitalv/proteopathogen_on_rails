class CreatePeptideEvidences < ActiveRecord::Migration
  def change
    create_table :peptide_evidences do |t|
      t.string :peptide_evidence_id, :null => false
      t.string :db_sequence_ref, :null => false
      t.references :spectrum_identification_item
      t.references :peptide
      t.integer :start
      t.integer :end
      t.string :pre #use validation in the model for restriction
      t.string :post #use validation in the model for restriction
      t.boolean :is_decoy
      t.string :missed_cleavages
      t.timestamps
    end
  end
end
