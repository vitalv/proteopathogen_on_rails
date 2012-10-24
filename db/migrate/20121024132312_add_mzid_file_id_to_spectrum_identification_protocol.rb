class AddMzidFileIdToSpectrumIdentificationProtocol < ActiveRecord::Migration
  change_table :spectrum_identification_protocols do |t|
    t.references :mzid_file
  end
end
