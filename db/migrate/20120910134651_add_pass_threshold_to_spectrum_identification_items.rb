class AddPassThresholdToSpectrumIdentificationItems < ActiveRecord::Migration
  def up
    add_column :spectrum_identification_items, :pass_threshold, :string, :null => false
    change_column :spectrum_identification_items, :exp_m2z, :string, :null => false
    change_column :spectrum_identification_items, :rank, :integer, :null => false
    change_column :spectrum_identification_items, :charge_state, :integer, :null => false
  end
  def down
    remove_column :spectrum_identification_items, :pass_threshold
  end
  
end
