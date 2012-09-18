class SirPsiMsCvTerm < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_results
  validates :spectrum_identification_result_id, :presence => true
  validates :psi_ms_cv_term_accession, :presence => true
end
