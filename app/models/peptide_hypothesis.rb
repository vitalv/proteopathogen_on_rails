class PeptideHypothesis < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :protein_detection_hypothesis
  belongs_to :peptide_spectrum_assignment
  validates :protein_detection_hypothesis_id, uniqueness: {scope: :peptide_spectrum_assignment_id}, presence: true  
  validates :peptide_spectrum_assignment_id, uniqueness: {scope: :protein_detection_hypothesis_id}, presence: true  
end
