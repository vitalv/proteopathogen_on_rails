class AddSlugToMzidFiles < ActiveRecord::Migration
  def change
    add_column :mzid_files, :slug, :string
    add_index :mzid_files, :slug
  end
end
