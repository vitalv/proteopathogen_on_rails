class AddUniqMzidfileName < ActiveRecord::Migration
  def change
    add_index :mzid_files, :name, :unique => true
  end
end
