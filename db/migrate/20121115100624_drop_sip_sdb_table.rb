class DropSipSdbTable < ActiveRecord::Migration

  def up
    drop_table :sip_sdb_join_table
  end

  def down
    create_table :sip_sdb_join_table, :id => false do |t|
      t.integer :search_database_id
      t.integer :spectrum_identification_protocol_id
    end
    add_index(:sip_sdb_join_table, [:search_database_id, :spectrum_identification_protocol_id], :name => 'index_sip_sdb')
  end
end
