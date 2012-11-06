class RemoveSampleIdFromSpectraAcquisitionRuns < ActiveRecord::Migration
  change_table :spectra_acquisition_runs do |t|
    t.remove :sample_id
  end
end
