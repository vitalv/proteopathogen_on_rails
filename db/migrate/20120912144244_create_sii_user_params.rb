class CreateSiiUserParams < ActiveRecord::Migration
  def change
    create_table :sii_user_params do |t|
      t.references :spectrum_identification_item
      t.string :name
      t.string :value
    end
  end
end
