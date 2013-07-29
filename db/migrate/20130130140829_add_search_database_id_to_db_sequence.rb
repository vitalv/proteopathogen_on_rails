class AddSearchDatabaseIdToDbSequence < ActiveRecord::Migration
  def up
    change_table :db_sequences do |t|
      t.references :search_database
    end
  end
  def down
    #remove_column :db_sequences, :search_database_id
  end
end
