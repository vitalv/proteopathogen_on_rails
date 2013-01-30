class AddSearchDatabaseIdToDbSequence < ActiveRecord::Migration
  def change
    change_table :db_sequences do |t|
      t.references :search_database
    end
  end
end
