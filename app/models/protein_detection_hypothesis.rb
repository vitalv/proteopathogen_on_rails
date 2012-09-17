class ProteinDetectionHypothesis < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :protein_detection_hypothesis_id, :presence => true
  validates :pass_threshold, :presence => true
  has_many :sii_peptide_evidences, :dependent => destroy
end
