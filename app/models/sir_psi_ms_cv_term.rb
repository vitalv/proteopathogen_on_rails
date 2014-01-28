class SirPsiMsCvTerm < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_result
  validates :spectrum_identification_result_id, presence: true
  validates :psi_ms_cv_term, presence: true
  
  def ms_term_name 
    accession = self.psi_ms_cv_term
    return PsiMsCvTerm.where(accession: accession)[0].name
  end
  
end
