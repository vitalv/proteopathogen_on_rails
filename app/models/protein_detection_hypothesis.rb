class ProteinDetectionHypothesis < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :protein_detection_hypothesis_id, :presence => true
  validates :pass_threshold, :presence => true
  #has_and_belongs_to_many :peptide_evidences, :join_table => 'protein_hypothesis_pepevidence_join_table'
  belongs_to :protein_ambiguity_group
  has_many :protein_detection_hypothesis_psi_ms_cv_terms, :dependent => destroy
  has_many :protein_detection_hypothesis_user_params, :dependent => destroy
end
