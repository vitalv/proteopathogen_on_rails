class RenameSamplesToExperiments < ActiveRecord::Migration
  def change
    rename_table :samples, :experiments
  end
end
