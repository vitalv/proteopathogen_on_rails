class AddSdbIdToSearchDatabase < ActiveRecord::Migration
  def change
    add_column :search_databases, :sdb_id, :string, :null => false
  end
end
