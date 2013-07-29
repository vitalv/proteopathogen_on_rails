class SiiPsiMsCvTerm < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_item
  validates :spectrum_identification_item_id, presence: true
  validates :psi_ms_cv_term_accession, uniqueness: {scope: :spectrum_identification_item_id}, presence: true
 
end
