class RemoveSpectrumIdentificationListIdFromSpectrumIdentification < ActiveRecord::Migration
  def up
    remove_column :spectrum_identifications, :spectrum_identification_list_id
  end

  def down
    add_column :spectrum_identifications, :spectrum_identification_list_id, :integer  
  end
end
