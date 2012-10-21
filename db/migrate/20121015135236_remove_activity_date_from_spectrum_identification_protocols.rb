class RemoveActivityDateFromSpectrumIdentificationProtocols < ActiveRecord::Migration
  def change
    remove_column :spectrum_identification_protocols, :activity_date
  end
end
