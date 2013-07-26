class AddMzidFileIdToSpectrumIdentifications < ActiveRecord::Migration
  def change
    change_table :spectrum_identifications do |t|
      t.references :mzid_file
    end     
  end
end
