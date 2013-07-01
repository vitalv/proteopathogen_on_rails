class Modification < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :peptide_sequence
  validates :peptide_sequence_id, :presence => true
  belongs_to :peptide_evidence
  validates :peptide_evidence_id, :presence => true
end
