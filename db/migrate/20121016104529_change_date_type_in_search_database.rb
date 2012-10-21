class ChangeDateTypeInSearchDatabase < ActiveRecord::Migration
  def up
    change_column :search_databases, :release_date, :string
  end

  def down
    change_column :search_databases, :release_date, :date
  end
end
