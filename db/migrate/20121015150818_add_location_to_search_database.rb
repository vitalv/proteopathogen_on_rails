class AddLocationToSearchDatabase < ActiveRecord::Migration
  def change
    add_column :search_databases, :location, :string
  end
end
