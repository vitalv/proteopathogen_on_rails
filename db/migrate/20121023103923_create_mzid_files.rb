class CreateMzidFiles < ActiveRecord::Migration
  def change
    create_table :mzid_files do |t|
      t.string :location
      t.string :sha1
      t.string :creator
      t.string :submission_date
    end
  end
end
