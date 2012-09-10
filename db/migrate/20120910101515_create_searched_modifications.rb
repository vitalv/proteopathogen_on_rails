class CreateSearchedModifications < ActiveRecord::Migration
  def change
    create_table :searched_modifications do |t|
      t.references :spectrum_identification_protocol, :null => false
      t.float :mass_delta
<<<<<<< HEAD
      t.boolean :is_fixed
=======
      t.bool :is_fixed
>>>>>>> 37ba5eb901adecb733eb4e4cc88673082c7b4600
      t.string :residue
      t.timestamps
    end
  end
end
