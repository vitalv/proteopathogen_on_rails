class CreateDbSequences < ActiveRecord::Migration
  def change
    create_table :db_sequences do |t|
      t.string :accession
      t.text :description
      t.text :sequence
    end
  end
end
