class RemoveOrganismFromSearchDatabase < ActiveRecord::Migration
  def change
    remove_column :search_databases, :organism
  end
end
