class RemoveDecoyTypeFromSearchDatabase < ActiveRecord::Migration
  def change
    remove_column :search_databases, :decoy_type
  end
end
