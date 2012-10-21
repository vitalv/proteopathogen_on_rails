class RemoveSearchDatabaseIdFromSpectrumIdentificationProtocols < ActiveRecord::Migration
  def change
    remove_column :spectrum_identification_protocols, :search_database_id
  end
end
