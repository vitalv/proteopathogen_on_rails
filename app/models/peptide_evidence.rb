class PeptideEvidence < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :peptide_id, :presence => true
  belongs_to :peptide
  has_many :sii_peptide_evidences, :dependent => destroy
  has_many :protein_hypothesis_peptide_evidences ,:dependent => destroy
end
