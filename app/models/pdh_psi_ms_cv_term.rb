class PdhPsiMsCvTerm < ActiveRecord::Base
  belongs_to :protein_detection_hypothesis
  validates :protein_detection_hypothesis_id, presence: true
  validates :psi_ms_cv_term_accession, presence: true  
end
