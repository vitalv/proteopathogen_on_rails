class CreateProteinAmbiguityGroups < ActiveRecord::Migration
  def change
    create_table :protein_ambiguity_groups do |t|
      t.string :protein_ambiguity_group_id
    end
  end
end
