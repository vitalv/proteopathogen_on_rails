class AddNameToMzidFile < ActiveRecord::Migration
  def change
    add_column :mzid_files, :name, :string
  end
end
