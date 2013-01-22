class CreateSpectraAcquisitionRuns < ActiveRecord::Migration
  def change
    create_table :spectra_acquisition_runs do |t|
      t.string :fraction
      t.string :instrument
      t.string :ionization
      t.string :analyzer
    end
  end
end
