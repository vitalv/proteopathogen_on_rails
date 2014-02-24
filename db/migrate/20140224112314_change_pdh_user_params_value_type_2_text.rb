class ChangePdhUserParamsValueType2Text < ActiveRecord::Migration
  def up 
    change_column :pdh_user_params, :value, :text
  end
  
  def down
    change_column :pdh_user_params, :value, :string
  end
end
