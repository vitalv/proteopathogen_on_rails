class SipPsiMsCvTerm < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_protocol
  validates :spectrum_identification_protocol_id, presence: true
  
  def ms_term_name 
    accession = self.psi_ms_cv_term_accession
    return PsiMsCvTerm.where(accession: accession)[0].name
  end
  
  
end
