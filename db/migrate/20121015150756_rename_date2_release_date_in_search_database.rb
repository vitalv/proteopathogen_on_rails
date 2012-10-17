class RenameDate2ReleaseDateInSearchDatabase < ActiveRecord::Migration
  def change
    rename_column :search_databases, :date, :release_date
  end
end
