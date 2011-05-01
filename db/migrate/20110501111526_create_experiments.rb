class CreateExperiments < ActiveRecord::Migration
  def self.up
    create_table :experiments do |t|
      t.text :title
      t.string :reference
      t.string :sample
      t.text :protocol
      t.boolean :has_quantitative_data
      t.boolean :public

      t.timestamps
    end
  end

  def self.down
    drop_table :experiments
  end
end
