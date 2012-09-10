class CreateSearchedModifications < ActiveRecord::Migration
  def change
    create_table :searched_modifications do |t|

      t.timestamps
    end
  end
end
