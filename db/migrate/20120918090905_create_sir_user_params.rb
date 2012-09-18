class CreateSirUserParams < ActiveRecord::Migration
  def change
    create_table :sir_user_params do |t|
      t.references :spectrum_identification_result, :null => false
      t.string :name 
      t.string :value
    end
  end
end
