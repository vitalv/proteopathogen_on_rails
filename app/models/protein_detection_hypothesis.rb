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
  
  def db_seq_description
  #note: <ProteinDetectionHypothesis has an optional attr dBSequence_ref but "is optional and redundant since the PeptideEvidence elements referenced from here also map to the DBSequence"
  #that is why PDH is not linked to db_seq_ref, but I nevetheless need access to db_seq_things to display on protein_detection controller and views:
    db_seq_descr_arr = self.peptide_hypotheses.collect { |pdh| pdh.peptide_spectrum_assignment.peptide_evidence.db_sequence.description}
    #check all the collected peptide_hypotheses refer to one db_seq:
    return db_seq_descr_arr.compact.uniq[0] if db_seq_descr_arr.uniq.length == 1
  end


  def db_seq_sequence
  #note: same thing applies as with db_seq_description
    db_seq_sequence_arr = self.peptide_hypotheses.collect { |pdh| pdh.peptide_spectrum_assignment.peptide_evidence.db_sequence.sequence}
    return db_seq_sequence_arr.compact.uniq[0] if db_seq_sequence_arr.uniq.length == 1
  end
  
  def cgdid
    if self.db_seq_description and self.db_seq_description.include? "CGDID:"
      return self.db_seq_description.match(/CGDID:CA[L|F]\d+/).to_s.split(":")[1]
    end
  end
  

end
