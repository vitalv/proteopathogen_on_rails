class AddUnimodAccessionToSearchedModifications < ActiveRecord::Migration
  def up
    add_column :searched_modifications, :unimod_accession, :string
  end
end
