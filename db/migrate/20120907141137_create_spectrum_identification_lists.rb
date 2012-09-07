class CreateSpectrumIdentificationLists < ActiveRecord::Migration
  def change
    create_table :spectrum_identification_lists do |t|
      t.string :sil_id, :null => false
      t.references :spectrum_identification_protocol

      t.timestamps
    end
  end
end
