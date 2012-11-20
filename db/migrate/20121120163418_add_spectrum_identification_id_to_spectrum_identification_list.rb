class AddSpectrumIdentificationIdToSpectrumIdentificationList < ActiveRecord::Migration
  change_table :spectrum_identification_lists do |t|
    t.references :spectrum_identification
  end
end
