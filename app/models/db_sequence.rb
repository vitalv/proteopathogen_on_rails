class DbSequence < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :peptide_evidences
  #validates :sequence, :presence => true
  validates :accession, uniqueness: {scope: :search_database_id}, presence: true
  belongs_to :search_database
  validates :search_database_id, presence: true
  
  
  #Note: uniq_pep_sequences and pep_evidences_freq_hash are methods
  #that return peptides maping to self peptides in global context, not one particular experiment/spectrum_identification 
  
  def uniq_pep_sequences
    unless self.peptide_evidences.empty?
      return self.peptide_evidences.map{|pep_ev| pep_ev.peptide_sequence.sequence}.uniq
    end
  end
  
  def pep_evidences_freq_hash
    unless self.peptide_evidences.empty?
      prot_peps = self.peptide_evidences.map{|pep_ev| pep_ev.peptide_sequence.sequence}
      return prot_peps.inject(Hash.new(0)){|h,e| h[e]+=1; h}
    end
  end
  
  
  def prot_seq_highlighted_coverage(coverage_offsets)
    prot_seq_w_highlighted_coverage = ""
    prot_seq_arr = self.sequence.split("")
    prot_seq_arr.each_with_index do |aa, i|
      coverage_offsets.each do |offsets|
        prot_seq_arr[i] = "&nbsp;<span class='cov'>#{aa}" if i == offsets[0]
        prot_seq_arr[i] = "#{aa}</span>&nbsp;" if i == offsets[1]-1
      end
    end
    return prot_seq_w_highlighted_coverage = prot_seq_arr.join
  end  
  
  

end
