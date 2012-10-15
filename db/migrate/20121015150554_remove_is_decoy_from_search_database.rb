class RemoveIsDecoyFromSearchDatabase < ActiveRecord::Migration
  def change
    remove_column :search_databases, :is_decoy
  end
end
