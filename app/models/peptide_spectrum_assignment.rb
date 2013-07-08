class PeptideSpectrumAssignment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_item
  validates :spectrum_identification_item_id, :presence => true
  belongs_to :peptide_evidence
  validates :peptide_evidence_id, :presence => true
  
  validates_uniqueness_of :spectrum_identification_item_id, :scope => :peptide_evidence_id
  
  has_many :peptide_hypotheses
  has_many :protein_detection_hypotheses, :through => :peptide_hypotheses
  
end
