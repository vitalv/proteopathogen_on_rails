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
  
  #NOTE: ESTO NO ES NECESARIO, PORQUE NO OCURRE NUNCA SI EL .MZID ES CORRECTO, VER protein_detection controller
  #def has_ambiguous_peptides
  ##Note, I am not sure whether this is even possible but <PeptideHypotheses> under <PDH> may ref to different proteins (DbSequence)
  ##NO it's not you dumbass!
  #  db_seq_ids = self.peptide_hypotheses.map { |pep_h| pep_h.peptide_spectrum_assignment.peptide_evidence.db_sequence_id }
  #  return true if db_seq_ids.uniq.count != 1
  #end
  
  def db_seq
    #unless self.has_ambiguous_peptides #see above
    unless self.peptide_hypotheses.blank?
      return self.peptide_hypotheses[0].peptide_spectrum_assignment.peptide_evidence.db_sequence
    end    
  end
  
  def db_seq_description
    return self.db_seq.description if self.db_seq
  end
  
  def cgdid
    if self.db_seq_description and self.db_seq_description.include? "CGDID:"
      return self.db_seq_description.match(/CGDID:CA[L|F]\d+/).to_s.split(":")[1]
    end
  end
  

  def psms
    psms = self.peptide_spectrum_assignments
    psms_h, psm_freq = {} , {}
    psms.each { |psm| psms_h[psm.spectrum_identification_item.short_sii_id] = psm.peptide_evidence.peptide_sequence.sequence }
    seq_freq = psms_h.values.inject(Hash.new(0)){ |h,v| h[v] += 1; h}
    seq_freq.each do |seqk, siis_count|
      siis, sii_a = [], []
      psms_h.each do |sii, seqv|
        if siis_count == 1
          if seqk == seqv
            sii_a = [sii, 1]
            psm_freq[seqk] = sii_a 
          end
        elsif siis_count > 1
          siis << sii if seqk == seqv
        end
      end
      if siis_count > 1
        sii_a = [siis.join(", "), siis_count]
        psm_freq[seqk] = sii_a
      end
    end
    return psm_freq
  end



end
