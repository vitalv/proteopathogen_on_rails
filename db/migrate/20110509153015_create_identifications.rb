class CreateIdentifications < ActiveRecord::Migration
  def self.up
    create_table :identifications do |t|
      t.references :experiment, :null => false
      t.string :search_database, :null => false
      t.string :search_engine
      t.column :score, 'decimal(22,6)'
      t.column :threshold, 'decimal(22,6)'
      t.column :molecular_weight, 'decimal(12,6)'
      t.column :pi, 'decimal(12,6)'
      t.column :seq_coverage, 'decimal(12,6)'
      t.timestamps
    end
  end

  def self.down
    drop_table :identifications
  end
end
