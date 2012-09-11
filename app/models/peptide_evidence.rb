class PeptideEvidence < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :peptide_evidence_id, :presence => true
  belongs_to :spectrum_identification_item

end
