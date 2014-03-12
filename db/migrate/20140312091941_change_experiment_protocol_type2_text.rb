class ChangeExperimentProtocolType2Text < ActiveRecord::Migration
  def up 
    change_column :experiments, :protocol, :text
  end
  
  def down
    change_column :experiments, :protocol, :string
  end
end
