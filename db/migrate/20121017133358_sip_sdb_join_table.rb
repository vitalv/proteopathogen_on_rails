class SipSdbJoinTable < ActiveRecord::Migration
  def up
    create_table :sip_sdb_join_table, :id => false do |t|
      t.integer :search_database_id
      t.integer :spectrum_identification_protocol_id
    end
    add_index(:sip_sdb_join_table, [:search_database_id, :spectrum_identification_protocol_id], :name => 'index_sip_sdb')
  end

  def down
    drop_table :sip_sdb_join_table
  end
end
