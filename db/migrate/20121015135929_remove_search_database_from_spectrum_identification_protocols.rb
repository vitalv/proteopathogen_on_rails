class RemoveSearchDatabaseFromSpectrumIdentificationProtocols < ActiveRecord::Migration
  def change
    remove_column :spectrum_identification_protocols, :search_database
  end
end
