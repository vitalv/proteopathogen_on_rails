class RemoveSpectrumIdentificationProtocolIdFromSpectrumIdentification < ActiveRecord::Migration
  def up
    remove_column :spectrum_identifications, :spectrum_identification_protocol_id
  end

  def down
    add_column :spectrum_identifications, :spectrum_identification_protocol_id, :integer
  end
end
