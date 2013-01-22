class AddSampleIdToSpectraAcquisitionRun < ActiveRecord::Migration
  def change
    add_column :spectra_acquisition_runs, :sample_id, :integer, :null => false
  end
end
