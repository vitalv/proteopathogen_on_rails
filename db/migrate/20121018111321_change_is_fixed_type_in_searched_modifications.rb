class ChangeIsFixedTypeInSearchedModifications < ActiveRecord::Migration
  def up
    change_column :searched_modifications, :is_fixed, :boolean
  end

  def down
    change_column :searched_modifications, :is_fixed, :string
  end
end
