class AddNameAndActivityDateToSpectrumIdentifications < ActiveRecord::Migration
  change_table :spectrum_identifications do |t|
    t.string :name
    t.string :activity_date
  end
end
