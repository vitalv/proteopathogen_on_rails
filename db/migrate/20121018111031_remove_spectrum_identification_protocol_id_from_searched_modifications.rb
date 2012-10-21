class RemoveSpectrumIdentificationProtocolIdFromSearchedModifications < ActiveRecord::Migration
  def change
    remove_column :searched_modifications, :spectrum_identification_protocol_id
  end
end
