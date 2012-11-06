class AddExperimentIdToMzidFiles < ActiveRecord::Migration
  change_table :mzid_files do |t|
    t.references :experiment
  end
end
