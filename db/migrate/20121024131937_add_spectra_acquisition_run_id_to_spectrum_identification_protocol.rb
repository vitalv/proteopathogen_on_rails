class AddSpectraAcquisitionRunIdToSpectrumIdentificationProtocol < ActiveRecord::Migration
  change_table :spectrum_identification_protocols do |t|
    t.references :spectra_acquisition_run
  end
end
