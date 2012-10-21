class CreateDbSequences < ActiveRecord::Migration
  def change
    create_table :db_sequences do |t|
      t.string :accession
      t.string :description
      t.text :sequence
    end
  end
end
