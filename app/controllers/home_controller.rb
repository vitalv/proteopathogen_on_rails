class HomeController < ApplicationController
  
  def index
    
    @experiment_count = Experiment.all.count
    @mzid_file_count = MzidFile.all.count
    @peptide_evidence_count = PeptideEvidence.all.count
    @peptide_sequence_count = PeptideSequence.all.count
    @psm_count = PeptideSpectrumAssignment.all.count
    @pdh_count = ProteinDetectionHypothesis.all.count
  end

end
