class CreateSpectrumIdentifications < ActiveRecord::Migration
  def change
    create_table :spectrum_identifications do |t|
      t.references :spectrum_identification_protocol
      t.references :spectrum_identification_list
    end
  end
end
