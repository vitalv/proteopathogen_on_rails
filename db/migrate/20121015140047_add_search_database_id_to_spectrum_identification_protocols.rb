class AddSearchDatabaseIdToSpectrumIdentificationProtocols < ActiveRecord::Migration
  change_table :spectrum_identification_protocols do |t|
    t.references :search_database
  end
end
