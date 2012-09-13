class SiiPeptideEvidence < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :spectrum_identification_item_id, :presence => true
  validates :peptide_evidence_id, :presence => true
end
