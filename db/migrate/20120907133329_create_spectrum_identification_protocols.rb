class CreateSpectrumIdentificationProtocols < ActiveRecord::Migration
  def change
    create_table :spectrum_identification_protocols do |t|
      t.string :sip_id, :null => false
      t.string :activity_date
      t.string :input_spectra
      t.string :search_database
      t.string :analysis_software
      t.string :search_type

      t.timestamps
    end
    
  end
  
end
