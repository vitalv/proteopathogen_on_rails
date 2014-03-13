class AddUniqExperimentShortLabel < ActiveRecord::Migration
  def change
    add_index :experiments, :short_label, :unique => true
  end
end
