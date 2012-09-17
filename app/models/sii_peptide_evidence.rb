class SiiPeptideEvidence < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_item
  belongs_to :peptide_evidence
  validates :spectrum_identification_item_id, :presence => true
  validates :peptide_evidence_id, :presence => true
end
