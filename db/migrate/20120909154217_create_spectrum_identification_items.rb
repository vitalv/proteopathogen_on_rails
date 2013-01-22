class CreateSpectrumIdentificationItems < ActiveRecord::Migration
  def change
    create_table :spectrum_identification_items do |t|
      t.string :sii_id, :null => false
      t.references :spectrum_identification_result
      t.string :calc_m2z
      t.string :exp_m2z, :null => false #required in <SpectrumIdentificationItem>
      t.integer :rank, :null => false #required in <SpectrumIdentificationItem>
      t.integer :charge_state, :null => false #required in <SpectrumIdentificationItem>
      t.string :pass_threshold, :null => false #required in <SpectrumIdentificationItem>
      t.timestamps
    end
  end
end
