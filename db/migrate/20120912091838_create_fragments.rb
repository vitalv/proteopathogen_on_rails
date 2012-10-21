class CreateFragments < ActiveRecord::Migration
  def change
    create_table :fragments do |t|
      t.references :spectrum_identification_item
      t.integer :charge
      t.integer :index
      t.float :m_mz
      t.integer :m_intensity
      t.float :m_error
      t.string :fragment_type
      t.string :psi_ms_cv_fragment_type_accession
      t.timestamps
    end
  end
end
