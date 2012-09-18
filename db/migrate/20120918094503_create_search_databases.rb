class CreateSearchDatabases < ActiveRecord::Migration
  def change
    create_table :search_databases do |t|
      t.string :name
      t.string :version
      t.datetime :date
      t.string :organism
      t.integer :number_of_sequences
      t.boolean :is_decoy
      t.string :decoy_type      
    end
  end
end
