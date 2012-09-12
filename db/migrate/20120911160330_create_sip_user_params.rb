class CreateSipUserParams < ActiveRecord::Migration
  def change
    create_table :sip_user_params do |t|
      t.references :spectrum_identification_protocol
      t.string :name
      t.string :value
    end
  end
end
