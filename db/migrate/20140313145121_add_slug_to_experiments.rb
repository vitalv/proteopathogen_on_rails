class AddSlugToExperiments < ActiveRecord::Migration
  def change
    add_column :experiments, :slug, :string
    add_index :experiments, :slug
  end
end
