class CreateSdbSiJoinTable < ActiveRecord::Migration
  def up
    create_table :sdb_si_join_table, :id => false do |t|
      t.integer :search_database_id
      t.integer :spectrum_identification_id
    end
    add_index(:sdb_si_join_table, [:search_database_id, :spectrum_identification_id], :name => 'index_sdb_si')
  end

  def down
    drop_table :sdb_si_join_table
  end
end
