class SiiPsiMsCvTerm < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_item
  validates :spectrum_identification_item_id, presence: true
  validates :psi_ms_cv_term_accession, uniqueness: {scope: :spectrum_identification_item_id}, presence: true
  
  #private
 
  def ms_term_name 
    accession = self.psi_ms_cv_term_accession
    return PsiMsCvTerm.where(accession: accession)[0].name
  end
 
end
