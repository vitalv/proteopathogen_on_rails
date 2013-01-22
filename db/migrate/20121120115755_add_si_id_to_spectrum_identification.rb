class AddSiIdToSpectrumIdentification < ActiveRecord::Migration
  def change
    add_column :spectrum_identifications, :si_id, :string, :null => false
  end
end
