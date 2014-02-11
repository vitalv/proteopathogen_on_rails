class Modification < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :peptide_sequence
  validates :peptide_sequence_id, :presence => true
  belongs_to :peptide_evidence
  validates :peptide_evidence_id, :presence => true
  validates :location, :presence => true
  validates_uniqueness_of :location, :scope => [:peptide_sequence_id, :peptide_evidence_id], :case_sensitive => false
  
  def unimod_name
    unless self.unimod_accession.nil?
      return UnimodCvTerm.where(accession: self.unimod_accession)[0].name
    end
  end
  
end
