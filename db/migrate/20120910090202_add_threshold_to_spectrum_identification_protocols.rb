class AddThresholdToSpectrumIdentificationProtocols < ActiveRecord::Migration
  def change
    add_column :spectrum_identification_protocols, :threshold, :string, :null => false

  end
end
