class CreatePeptideHypotheses < ActiveRecord::Migration
  def change
    create_table :peptide_hypotheses do |t|
      t.references :peptide_evidence, :null => false # belongs_to / has_one 
      t.references :spectrum_identification_item, :null => false #belongs_to many
      t.references :protein_detection_hypothesis, :null => false #belongs_to_many
    end
  end
end
