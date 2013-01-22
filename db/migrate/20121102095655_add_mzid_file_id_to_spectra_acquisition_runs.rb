class AddMzidFileIdToSpectraAcquisitionRuns < ActiveRecord::Migration
  change_table :spectra_acquisition_runs do |t|
    t.references :mzid_file
  end
end
