class PeptideHypothesis < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :protein_detection_hypothesis
  belongs_to :peptide_spectrum_assignment
  
end
