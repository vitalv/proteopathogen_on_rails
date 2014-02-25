class PeptideEvidence < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :peptide_sequence_id, presence: true 
  validates :db_sequence_id, presence: true
  validates :pepev_id, presence: true 
  
  #There MUST only be one PeptideEvidence item per Peptide-to-DBSequence-position
  #validates_uniqueness_of :peptide_sequence_id, :scope => [:db_sequence_id, :start, :end]
  #Peptide-to-DBSequence-position!! not PeptideSequence-to-DBSequence-position!! 
  #validates_uniqueness_of :pepev_id, :scope => [:db_sequence_id, :start, :end]
  
  belongs_to :peptide_sequence
  belongs_to :db_sequence
  has_many :peptide_spectrum_assignments, dependent: :destroy
  has_many :spectrum_identification_items, through: :peptide_spectrum_assignments
  has_many :modifications
  
  
  def modified_seq_html_string
    unless self.modifications.blank?
      pep_seq_arr = self.peptide_sequence.sequence.split("")      
      pep_seq_arr.each_with_index do |aa, i|
        self.modifications.each do |m|
          pep_seq_arr[i] = "<span class='mod'>#{aa}</span>" if i == m.location.to_i-1
        end
      end
      return pep_seq_arr.join
    end    
  end
  
  def matches_decoy_protein
    if self.db_sequence.accession =~ /decoy/i
      return "true" 
    else
      return "false"
    end
  end
  
end
