class PeptideEvidence < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :peptide_evidence_id, :presence => true
  validates :peptide_id, :presence => true
  belongs_to :spectrum_identification_item
  belongs_to :peptide

end
