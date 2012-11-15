class RemoveSpectraAcquisitionRunIdFromSpectrumIdentificationProtocols < ActiveRecord::Migration
  def up
    remove_column :spectrum_identification_protocols, :spectra_acquisition_run_id
  end

  def down
    add_column :spectrum_identification_protocols, :spectra_acquistion_run_id, :integer
  end
end
