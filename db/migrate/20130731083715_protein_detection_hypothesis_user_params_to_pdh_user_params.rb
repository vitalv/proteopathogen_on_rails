class ProteinDetectionHypothesisUserParamsToPdhUserParams < ActiveRecord::Migration
  def change
    rename_table :protein_detection_hypothesis_user_params, :pdh_user_params
  end
end
