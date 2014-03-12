class AddShortExperimentLabel2Experiment < ActiveRecord::Migration
  def change
    add_column :experiments, :short_label, :string  
  end
end
