class AddSpectrumIdentificationIdToSpectrumIdentificationProtocol < ActiveRecord::Migration
  change_table :spectrum_identification_protocols do |t|
    t.references :spectrum_identification
  end
end
