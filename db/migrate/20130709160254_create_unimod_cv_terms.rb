class CreateUnimodCvTerms < ActiveRecord::Migration
  def change
    create_table :unimod_cv_terms do |t|
      t.string :accession
      t.string :name
    end
  end
end
