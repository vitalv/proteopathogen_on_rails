class AddSpectraFileToSpectraAcquisitionRun < ActiveRecord::Migration
  def change
    add_column :spectra_acquisition_runs, :spectra_file, :string
  end
end
