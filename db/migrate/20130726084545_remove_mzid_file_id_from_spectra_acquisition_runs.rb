class RemoveMzidFileIdFromSpectraAcquisitionRuns < ActiveRecord::Migration
  def up
   remove_column :spectra_acquisition_runs, :mzid_file_id
  end
  def down
    add_column :mzid_file_id, :spectra_acquisition_runs, :string
  end
end
