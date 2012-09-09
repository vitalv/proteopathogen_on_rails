class CreateSpectrumIdentificationResults < ActiveRecord::Migration
  def change
    create_table :spectrum_identification_results do |t|
      t.string :sir_id, :null => false
      t.references :spectrum_identification_list
      t.string :spectrum_id
      t.string :spectrum_name

      t.timestamps
    end
  end
end
