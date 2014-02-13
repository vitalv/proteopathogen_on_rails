class ProteinDetectionHypothesis < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :protein_detection_hypothesis_id, presence: true
  validates :pass_threshold, presence: true
  validates :protein_ambiguity_group_id, presence: true
  
  belongs_to :protein_ambiguity_group
  
  
  has_many :pdh_psi_ms_cv_terms, dependent: :destroy
  has_many :pdh_user_params, dependent: :destroy
  
  has_many :peptide_hypotheses, dependent: :destroy
  has_many :peptide_spectrum_assignments, through: :peptide_hypotheses
  
  #note: <ProteinDetectionHypothesis has an optional attr dBSequence_ref but "is optional and redundant since the PeptideEvidence elements referenced from here also map to the DBSequence"
  #that is why PDH is not linked to db_seq_ref, but I nevetheless need access to db_seq_things to display on protein_detection controller and views:
  
  def db_seq_mapping
    db_seq_ids = self.peptide_hypotheses.collect { |pep_h| pep_h.peptide_spectrum_assignment.peptide_evidence.db_sequence_id }
    return DbSequence.find(db_seq_ids[0]) if db_seq_ids.uniq.count == 1
  end
  
  def db_seq_description
    return self.db_seq_mapping.description if self.db_seq_mapping
  end
  
  def cgdid
    if self.db_seq_description and self.db_seq_description.include? "CGDID:"
      return self.db_seq_description.match(/CGDID:CA[L|F]\d+/).to_s.split(":")[1]
    end
  end
  

  def prot_seq_highlighted_coverage(coverage_offsets)
    prot_seq_w_highlighted_coverage = ""
    prot_seq_arr = self.db_seq_mapping.sequence.split("")
    prot_seq_arr.each_with_index do |aa, i|
       coverage_offsets.each do |offsets|
        prot_seq_arr[i] = "<span class='cov'>#{aa}" if i == offsets[0]
        prot_seq_arr[i] = "#{aa}</span>" if i == offsets[1]-1
      end
    end
    return prot_seq_w_highlighted_coverage = prot_seq_arr.join
  end


end
