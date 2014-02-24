class ChangeDbSeqDescriptionType2Text < ActiveRecord::Migration
  def up 
    change_column :db_sequences, :description, :text
  end
  
  def down
    change_column :db_sequences, :description, :string
  end
  
end
