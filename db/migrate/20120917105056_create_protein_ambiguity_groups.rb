class CreateProteinAmbiguityGroups < ActiveRecord::Migration
  def change
    create_table :protein_ambiguity_groups do |t|
      t.string :protein_ambiguity_group_id
      t.references :protein_detection_hypothesis
    end
  end
end
