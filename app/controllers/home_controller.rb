class HomeController < ApplicationController
  
  def index
    
    @experiment_count = Experiment.all.count
    @mzid_file_count = MzidFile.all.count
    @peptide_evidence_count = PeptideEvidence.all.count
    @peptide_sequence_count = PeptideSequence.all.count
    @psm_count = PeptideSpectrumAssignment.all.count
    @pdh_count = ProteinDetectionHypothesis.all.count
    #To get a number of proteins I can get:
    #Accessions from DbSequence
    @dbseq_accession_count = DbSequence.all.map { |d| d.accession}
    @distinct_dbseq_accession_count = DbSequence.all.map { |d| d.accession}.uniq.count #remember DbSeq accession is scoped to sdb_id in DbSeq model so I need the ".uniq" to get proteins are considered different 
    #Actual DbSequence (protein) sequences
    @dbseq_sequence_count = DbSequence.all.map { |d| d.sequence}.count
    
  end

end
