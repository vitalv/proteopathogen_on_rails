class DbSequence < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :peptide_evidences
  #validates :sequence, :presence => true
  validates :accession, uniqueness: {scope: :search_database_id}, presence: true
  belongs_to :search_database
  validates :search_database_id, presence: true
  
  
  def pep_evidences_freq_hash
    unless self.peptide_evidences.empty?
      prot_peps = self.peptide_evidences.map{|pep_ev| pep_ev.peptide_sequence.sequence}
      return prot_peps.inject(Hash.new(0)){|h,e| h[e]+=1; h}
    end
  end
  

end
