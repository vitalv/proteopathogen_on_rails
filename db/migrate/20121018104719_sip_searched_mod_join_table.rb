class SipSearchedModJoinTable < ActiveRecord::Migration
  def up
    create_table :sip_searched_mod_join_table, :id => false do |t|
      t.integer :searched_modification_id
      t.integer :spectrum_identification_protocol_id
    end
    add_index(:sip_searched_mod_join_table, [:searched_modification_id, :spectrum_identification_protocol_id], :name => 'index_sip_searched_mod')
  end

  def down
    drop_table :sip_searched_mod_join_table
  end
end
