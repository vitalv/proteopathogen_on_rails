class AddPmidToExperiments < ActiveRecord::Migration
  def change
    add_column :experiments, :pmid, :string  
  end
end
