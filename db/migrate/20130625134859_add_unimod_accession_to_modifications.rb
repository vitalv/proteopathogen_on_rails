class AddUnimodAccessionToModifications < ActiveRecord::Migration
  def change
    add_column :modifications, :unimod_accession, :string
  end
end
