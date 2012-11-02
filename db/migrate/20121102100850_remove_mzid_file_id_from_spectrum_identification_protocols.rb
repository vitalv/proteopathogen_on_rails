class RemoveMzidFileIdFromSpectrumIdentificationProtocols < ActiveRecord::Migration
  change_table :spectrum_identification_protocols do |t|
    t.remove :mzid_file_id
  end
end
