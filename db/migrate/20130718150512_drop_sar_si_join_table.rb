class DropSarSiJoinTable < ActiveRecord::Migration
  def up
    drop_table :sar_si_join_table
  end

  def down
    create_table :sar_si_join_table, :id => false do |t|
      t.integer :spectra_acquisition_run_id
      t.integer :spectrum_identification_id
    end
    add_index(:sar_si_join_table, [:spectra_acquisition_run_id, :spectrum_identification_id], :unique => true, :name => 'index_sar_si')    
  end
end
