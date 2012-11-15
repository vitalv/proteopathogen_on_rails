class RemoveInputSpectraFromSpectrumIdentificationProtocols < ActiveRecord::Migration
  def up
    remove_column :spectrum_identification_protocols, :input_spectra
  end

  def down
    add_column :spectrum_identification_protocols, :input_spectra, :string
  end
end
