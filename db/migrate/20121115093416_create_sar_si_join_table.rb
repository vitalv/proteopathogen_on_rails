class CreateSarSiJoinTable < ActiveRecord::Migration
  def up
    create_table :sar_si_join_table, :id => false do |t|
      t.integer :spectra_acquisition_run_id
      t.integer :spectrum_identification_id
    end
    add_index(:sar_si_join_table, [:spectra_acquisition_run_id, :spectrum_identification_id], :name => 'index_sar_si')
  end

  def down
    drop_table :sar_si_join_table
  end
end
