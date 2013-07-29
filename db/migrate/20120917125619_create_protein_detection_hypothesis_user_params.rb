class CreateProteinDetectionHypothesisUserParams < ActiveRecord::Migration
  def change
    create_table :protein_detection_hypothesis_user_params do |t|
      t.references :protein_detection_hypothesis
      t.text :name
      t.text :value
    end
  end
end
