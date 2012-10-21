class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :organism
      t.string :protocol
      t.string :date
      t.string :researcher
    end
  end
end
