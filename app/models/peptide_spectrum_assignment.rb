class PeptideSpectrumAssignment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_item
  validates :spectrum_identification_item_id, uniqueness: {scope: :peptide_evidence_id}, presence: true
  belongs_to :peptide_evidence
  validates :peptide_evidence_id, uniqueness: {scope: :spectrum_identification_item_id}, presence: true  
  has_many :peptide_hypotheses, dependent: :destroy
  has_many :protein_detection_hypotheses, :through => :peptide_hypotheses  
end
