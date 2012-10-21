class AddTolerancesToSpectrumIdentificationProtocol < ActiveRecord::Migration
  def change
    add_column :spectrum_identification_protocols, :parent_tol_plus_value, :string
    add_column :spectrum_identification_protocols, :parent_tol_minus_value, :string
    add_column :spectrum_identification_protocols, :fragment_tol_plus_value, :string
    add_column :spectrum_identification_protocols, :fragment_tol_minus_value, :string
  end
end
