class CreateModifications < ActiveRecord::Migration
  def change      
    create_table :modifications do |t|
      t.string :residue
      t.string :location
      t.string :avg_mass_delta
      t.timestamps
    end
  end
end
