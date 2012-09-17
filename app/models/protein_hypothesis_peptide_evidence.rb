class ProteinHypothesisPeptideEvidence < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :protein_detection_hypothesis
  belongs_to :peptide_evidence
  validates :protein_detection_hypothesis_id, :presence => true
  validates :peptide_evidence_id, :presence => true
end
