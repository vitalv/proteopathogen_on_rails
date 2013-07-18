class AddSpectrumIdentificationIdToSpectraAcquisitionRuns < ActiveRecord::Migration
  def change
    change_table :spectra_acquisition_runs do |t|
      t.references :spectrum_identification
    end   
  end
end
