class AddProteinDetectionListIdToProteinAmbiguityGrou < ActiveRecord::Migration
    change_table :protein_ambiguity_groups do |t|
      t.references :protein_detection_list
    end  
end
