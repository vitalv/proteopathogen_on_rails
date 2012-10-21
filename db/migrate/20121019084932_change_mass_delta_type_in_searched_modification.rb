class ChangeMassDeltaTypeInSearchedModification < ActiveRecord::Migration
  def up
    change_column :searched_modifications, :mass_delta, :decimal, :precision => 4
  end

  def down
    change_column :searched_modifications, :mass_delta, :string
  end
end
