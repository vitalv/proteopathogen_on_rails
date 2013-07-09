class PeptideEvidence < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :peptide_sequence_id, :presence => true 
  validates :db_sequence_id, :presence => true
  validates :pepev_id, :presence => true 
  
  #There MUST only be one PeptideEvidence item per Peptide-to-DBSequence-position
  #validates_uniqueness_of :peptide_sequence_id, :scope => [:db_sequence_id, :start, :end]
  #Peptide-to-DBSequence-position!! not PeptideSequence-to-DBSequence-position!! 
  #validates_uniqueness_of :pepev_id, :scope => [:db_sequence_id, :start, :end]
  
  belongs_to :peptide_sequence
  belongs_to :db_sequence
  has_many :peptide_spectrum_assignments, :dependent => :destroy
  has_many :spectrum_identification_items, :through => :peptide_spectrum_assignments, :uniq => true
  has_many :modifications
end
