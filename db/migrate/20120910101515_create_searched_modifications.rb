class CreateSearchedModifications < ActiveRecord::Migration
  def change
    create_table :searched_modifications do |t|
      t.references :spectrum_identification_protocol, :null => false
      t.float :mass_delta
      t.bool :is_fixed
      t.string :residue
      t.timestamps
    end
  end
end
