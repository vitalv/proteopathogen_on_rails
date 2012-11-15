class RemoveSpectrumIdentificationProtocolIdFromSpectrumIdentificationLists < ActiveRecord::Migration
  def up
    remove_column :spectrum_identification_lists, :spectrum_identification_protocol_id
  end

  def down
    add_column :spectrum_identification_lists, :spectrum_identification_protocol_id, :integer
  end
end
